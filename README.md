### 📖 프로젝트 소개

  ![image](https://github.com/user-attachments/assets/968f40b6-70de-4b74-9f88-e9c187da5530)

폐기 직전 식품을 값싸게 거래하는 음식물 폐기 방지 모바일 앱

--------

### ⛰️ 프로젝트 목표
> #### 사용자 및 판매자 앱의 분리된 기능 최적화
소비자용 어플과 사장님용 어플로 목적에 맞는 기능만 수행하도록 분리하여 최적화된 환경을 제공한다.
>#### 프론트엔드와 백엔드의 긴밀한 통합
Flutter를 통한 프론트엔드 개발과 Java 백엔드 서비스의 통합을 통해 안정적이고 효율적인 애플리케이션을 구현한다.
>#### 의사소통과 협업 강화
정기적으로 회의를 진행하여 효과적인 의사소통과 협업을 통해 팀원 간의 의견을 조율하고 문제를 신속히 해결할 수 있는 환경을 조성한다.
>#### 다양한 기술 스택 학습 및 적용
Flutter, Dart, Java, Spring boot 등 다양한 기술 스택을 학습하고 적용하여, 현대적인 앱 개발 능력을 강화한다.

--------

### 👓 오픈소스 API 활용

> #### 국세청_사업자등록정보 진위확인 및 상태조회 서비스
사장님 앱에서 회원가입 시, 사업자가 맞는지 확인하는 용도로 사용
> #### 구글 맵 API
소비자 앱에서 사용자의 위치 기반으로 탐색하여, 주변 가게의 위치를 표시하는 용도로 사용
> #### openAI의 GPT-4o mini 모델
소비자가 상품을 볼 때, 상품에 맞는 추천 레시피를 생성하는 용도로 사용
앱에서 사용자가 상품을 보며 AI 로고를 클릭하면 구축한 플라스크 서버에 요청하여 AI의 요청을 받아옴

--------

### 👨🏻‍💻 기술스택
|**Category**|**Stack**|
|------|---|
|FE|Androdi Stdudio, Flutter, Dart|
|BE|IntelliJ, Spring boot, Java, AWS, Github Action, RDS, Python, Flask|
|Collaboration|Git, Github, Figma, Discord, Canva, Notion|
--------

### 🖥 ️주요 기능
<details>
<summary>로그인 화면</summary>
<div markdown="1">

  >#### 로그인 화면

<p align="center">
  
</p>

로그인을 통해 사용자가 간편하게 앱에 로그인할 수 있도록 한다. 회원가입을 할 때 사용자에 대한 정확한 정보를 얻도록 한다. 한 번 로그인을 진행하고 나면, 다음 번에 앱에 접속할 때 자동으로 로그인하여 보다 편리한 앱 사용감을 제공한다. 
</div>
</details>

> #### 소비자용 앱

<details>
<summary>홈 화면</summary>
<div markdown="1">

  >#### 홈 화면

<p align="center"> 
  
</p>

사용자가 접근하는 홈 화면은 반경 내 매장에서 판매중인 상품을 바로 확인할 수 있도록 하여 사용자 편의성을 고려한다. 사장님용 어플에서 등록된 상품이 소비자용 어플 홈화면에 카드형식으로 출력되고, 카드에는 등록된 상품의 사진, 상품의 이름, 상품의 마감기한까지 남은 시간, 매장 정보가 담겨있다. 상품카드들은 남은 마감시간을 기준으로 내림차순으로 정렬된다. 상품을 클릭하면 예약을 할 수 있는 화면으로 바로 넘어가게 되어 상품 예약 기능에 빠르게 접근할 수 있도록 한다. 상품수량이 모두 예약처리 된경우 해당 상품카드는 홈화면에서 제거된다.
  >#### 예약 화면

<p align="center"> 
  
</p>

예약 화면에서 해당 상품에 대한 AI의 레시피 추천, 사장님의 레시피 추천, 사용자의 레시피 추천을 확인할 수 있도록 하여 사용자에게 추가 정보를 제공한다. 예약하기 버튼을 통해 몇 개 예약할 것인지, 금액은 총 얼마인지 확인할 수 있다.
</div>
</details>

<details>
<summary>주변매장 화면</summary>
<div markdown="1">
  
  >#### 주변매장 화면

<p align="center"> 
  
</p>

지도를 통해 매장의 위치를 확인할 수 있는 화면이다. 매장 정보를 관리하는 데이터베이스에서 사용자의 위치를 기반으로 반경 4km 이내에 포함되어 있는 매장들을 필터링하고 지도에 마커를 보여주도록 한다. 이를 통해 소비자에게 불필요한 정보를 제공하지 않도록 한다. 또한 마커를 클릭하면 매장에 대한 정보를 확인할 수 있으며 하트 아이콘을 눌러 관심매장으로 등록할 수 있고 메뉴 버튼을 통해 매장 상세 화면으로 넘어간다.
  >#### 매장 상세 화면

<p align="center"> 
  
</p>

마커를 클릭한 후 매장 정보에서 메뉴 버튼을 클릭하면 해당 매장에서 판매하고 있는 상품들을 조회할 수 있다. 이를 통해 사용자가 원하는 매장의 상품들만 볼 수 있도록 한다.
</div>
</details>

<details>
<summary>마이냠 화면</summary>
<div markdown="1">

  >#### 마이냠 화면

<p align="center"> 
  
</p>

사용자의 정보를 관리하는 화면이다. 해당 화면에서 프로필 정보 수정 혹은 관심 매장 관리 화면으로 넘어갈 수 있다.
  >#### 프로필 수정 화면

<p align="center"> 
  
</p>

프로필 수정 화면에서는 프로필 이미지, 닉네임을 수정할 수 있다.
  >#### 관심 매장 관리 화면

<p align="center"> 
  
</p>

관심 매장 관리 화면에서는 사용자가 등록한 관심 매장의 목록을 확인할 수 있다. 해당 화면에서 관심 매장을 해제하거나 매장 상세 화면으로 넘어갈 수 있다.

</div>
</details>

<details>
<summary>주문 내역 화면</summary>
<div markdown="1">
  
  >#### 주문 내역 화면

<p align="center"> 
  
</p>

사용자가 이전에 어떤 상품을 주문했는지 확인할 수 있는 화면이다. 해당 화면에서 현재 예약중인 상품도 확인할 수 있어 현재 남은 시간이 얼마인지 빠르게 확인할 수 있다.
</div>
</details>

> #### 사장님용 앱

<details>
<summary>홈 화면</summary>
<div markdown="1">

  >#### 홈 화면

<p align="cente님용 앱

<details>
<summary>홈 화면</summary>
<div markdown="1">
  
  >#### 내정보 화면

<p align="center"> 
  
</p>

사용자가 등록한 상품들을 확인할 수 있는 화면이다. 이를 통해 상품을 품절처리하거나 숨김 기능도 가능하며 새로운 상품을 추가하는 상품 등록 화면으로 넘어갈 수 있다.
  >#### 상품 등록 화면

<p align="center"> 
  
</p>

상품 정보를 입력받아 상품을 등록할 수 있는 화면이다. 이를 통해 소비자용 어플에서 매장에서 등록한 상품을 예약할 수 있도록 한다.
</div>
</details>

<details>
<summary>냠냠판매 화면</summary>
<div markdown="1">

  >#### 냠냠판매 화면

<p align="center"> 
  
</p>

소비자가 예약 신청 시 수락하거나 취소할 수 있다. 취소 버튼을 클릭할 경우 소비자와 예약이 성립되지 않도록 하고 상품 갯수가 차감되지 않는다. 수락 버튼을 클릭할 경우 소비자와 예약이 성립되어 사장님이 등록한 예약 시간이 흐르게 된다. 예약 시간 타이머는 다른 화면을 갔다와도 유지되며 0이 될 경우 소비자가 상품을 수령하였는지 미수령하였는지 선택할 수 있으며, 시간 내에 상품을 수령했을 경우 미리 선택할 수 있다.
</div>
</details>

<details>
<summary>마이냠 화면</summary>
<div markdown="1">
  
  >#### 마이냠 화면

<p align="center"> 
  
</p>

사장님의 프로필 정보와 가게 정보를 관리할 수 있는 화면이다.
</div>
</details>


--------


### 👨‍👦‍👦 팀 명단
| Profile | Role | Part |
| ------- | ---- | ---- |
| <div align="center"><a href="https://github.com/ttatjwi"><img src="https://avatars.githubusercontent.com/u/144876617?v=4" width="70px;" alt=""/><br/><sub><b>이수영</b><sub></a></div> | 팀장 |  |
| <div align="center"><a href="https://github.com/geemmmii" width="70px;" alt=""/><img src="https://avatars.githubusercontent.com/u/108430795?v=4" width="70px;" alt=""/><br/><sub><b>김희겸</b></sub></a></div> | 팀원 |  |
| <div align="center"><a href="https://github.com/Jinoko01"><img src="https://avatars.githubusercontent.com/u/126740959?v=4" width="70px;" alt=""/><br/><sub><b>황용진</b></sub></a></div> | 팀원 | - 구글맵 API를 활용한 주변 매장 UI 및 기능 개발<br/>- 로그인/회원가입 UI 및 기능 개발<br/>- geolocator를 활용하여 주소 입력시 좌표로 변환하는 기능 개발<br/>- 예약시간 타이머 기능 개발<br/>- 사업자등록번호 검증 API를 활용하여 매장 검증 기능 개발<br/>- 소비자와 매장 간 예약처리 동시성 제어<br/>- imagePicker를 활용한 이미지 업로드 처리 | 
| <div align="center"><a href="https://github.com/jungbk0808"><img src="https://avatars.githubusercontent.com/u/120279225?v=4" width="70px;" alt=""/><br/><sub><b>정보경</b></sub></a></div> | 팀원 |  | 


--------

### 👀 추가 자료
1. [국세청_사업자등록정보 진위확인 및 상태조회 서비스](https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15081808)
2. [구글 맵 API](https://developers.google.com/maps?hl=ko)
3. [피그마 링크](https://www.figma.com/design/COYGETrMsqr0nRQN0J2onS/%EB%9D%BC%EC%8A%A4%ED%8A%B8-%EB%83%A0?node-id=167-1632&t=XLIBbFnmtqB03fLj-1)
