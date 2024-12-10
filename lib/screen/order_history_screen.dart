// lib/screen/order_history_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last_nyam/component/provider/user_state.dart';
import 'package:last_nyam/const/colors.dart';
import 'package:last_nyam/model/product.dart';
import 'package:last_nyam/service/reservation_service.dart';
import 'package:last_nyam/widget/order_item.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Reservation> reservations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final service = ReservationService();
      final data = await service.fetchReservations();
      setState(() {
        reservations = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _cancelReservation(int reservationId, int index) async {
    try {
      final service = ReservationService();
      await service.cancelReservation(reservationId);
      setState(() {
        reservations.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('예약이 취소되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('예약 취소에 실패했습니다: $e')),
      );
    }
  }

  Future<void> _updateReservationStatus(int index, String newStatus) async {
    try {
      final service = ReservationService();
      await service.updateReservationStatus(
          reservations[index].reservationId, newStatus);
      setState(() {
        reservations[index] = reservations[index].copyWith(status: newStatus);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('예약 상태가 업데이트되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('예약 상태 업데이트에 실패했습니다: $e')),
      );
    }
  }

  String _getProgressMessage(String status) {
    switch (status) {
      case 'BEFORE_ACCEPT':
        return '사장님이 주문을 확인하고 있어요.';
      case 'RESERVATION':
        return '사장님이 예약을 수락했어요, 가게에 방문하여 상품을 수령해주세요.';
      case 'CANCEL':
        return '예약이 취소되었습니다.';
      case 'RECEIVED':
        return '상품 수령이 완료되었습니다.';
      case 'NOT_RECEIVED':
        return '상품을 수령하지 않았습니다.';
      default:
        return '알 수 없는 상태입니다.';
    }
  }

  bool _isCompletedStatus(String status) {
    return status == 'RECEIVED' || status == 'NOT_RECEIVED';
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '주문 내역',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: reservations.isEmpty
          ? const Center(child: Text('주문 내역이 없습니다.'))
          : RefreshIndicator(
              onRefresh: _loadReservations,
              child: userState.isLogin
                  ? ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = reservations[index];
                        return OrderItem(
                          progress: _getProgressMessage(reservation.status),
                          storeName: reservation.storeName,
                          storeId: reservation.storeId.toString(),
                          // int을 String으로 변환
                          foodName: reservation.foodName,
                          amount: '${reservation.number}개',
                          // 'amount' 대신 'number' 사용
                          discountPrice: '${reservation.price}원',
                          isCompleted: _isCompletedStatus(reservation.status),
                          image: reservation.foodImage,
                          status: reservation.status,
                          reservationId: reservation.reservationId.toString(),
                          // int을 String으로 변환
                          onCancel: () => _cancelReservation(
                              reservation.reservationId, index),
                          onStatusChanged: (newStatus) =>
                              _updateReservationStatus(index, newStatus),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        '로그인 후 이용가능합니다.',
                        style: TextStyle(
                            color: defaultColors['lightGreen'], fontSize: 18),
                      ),
                    ),
            ),
    );
  }
}
