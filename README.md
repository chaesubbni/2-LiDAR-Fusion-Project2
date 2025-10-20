### 라이다 2개로 사람 인식 후 거리랑 키 추정하기

### 프로젝트 개요
- 이 프로젝트는 두 개의 라이다 센서를 통해 획득한 포인터클라우드 데이터를 회전 및 평행이동 행렬을 적용해 공통 좌표계로 융합하는 실습입니다.
- 이를 통해 자동차의 리프트 높이, 사람의 키, 그리고 두 객체 간의 거리를 정확히 계산할 수 있도록 구현했습니다.

### 리프트 높이 추정
- <img width="398" height="268" alt="image" src="https://github.com/user-attachments/assets/e2d5fa25-3e63-49a6-8e51-26ea035b70d2" />

### 차랑 사람 데이터만 추출
- <img width="373" height="417" alt="image" src="https://github.com/user-attachments/assets/0829ae43-1b30-46a7-9075-2b64e6a7945b" />

### 사람 키 추정
- <img width="252" height="42" alt="image" src="https://github.com/user-attachments/assets/e6f7c107-e06e-4f57-b41f-cce42cff6969" />

### 차량과 사람 거리 추정
- <img width="365" height="44" alt="image" src="https://github.com/user-attachments/assets/bba59b21-deb3-4b40-b1ee-9957067ba8ba" />

### 프로젝트 설명
- 두 라이다 센서로부터 데이터 수집
- 센서별 좌표계를 회전, 평행이동 행렬을 통해 동일한 월드 좌표계로 변환
- 변환된 데이터를 기반으로 자동차 리프트 높이, 사람의 키, 자동촤와 사람 간 최소 거리 추정
- 시각화

### 프로젝트 의의
- 다중 라이다 센서 융합 경험과 회전, 평행이동 등 수학적 개념을 실제 공간 데이터에 적용해 이해하기 더 좋았음.
- 데이터에서 의미있는 정보(사람인지, 장애물인지)를 추출하는 과정이 재밌었음.

