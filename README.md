# oneshot-cms-deploy

✍️ 코딩 과제 온라인 저지 플랫폼 Docker script

<br/>
<div style="text-align: center;">
<img src="http://cms-dev.github.io/screenshots/cws2.png" width="500"/>
<img src="http://cms-dev.github.io/screenshots/cws3.png" width="500"/>
</div>
<br/>

## 이게 뭔가요?

프로그래밍 컨테스트 플랫폼인 [CMS(Contest Management Platform)](http://cms-dev.github.io/)을
쉽게 배포할 수 있도록 쉘/도커 스크립트를 작성한 것입니다.

코로나19 사태로 인하여 온라인 강의가 많아진 상황에서,
온라인으로 쉽게 프로그래밍 과제를 제출할 수 있도록 교육자(교수, 조교, 강사)를 위하여 만들어졌습니다.

온라인 강의와 무관하게 온라인 저지 시스템을 구축하고자하는 누구나 사용할 수 있습니다.

## 실행 환경

- Ubuntu 18.04
- CMS1.4.rc1

## 실행 방법

### 0. 설치

```sh
sudo ./install.sh
```

- `http://localhost:8889`로 Admin 페이지 접속
  - 디폴트 계정: admin/nimda
  - docker-compose.yml의 `CMS_ADMIN_USERNAME`, `CMS_ADMIN_PASSWORD`값으로 계정 수정 가능
  - 또는 Admin 페이지에서 패스워드 수정 가능
- `http://localhost:9001`로 서비스 관리 화면(supervisord) 접속
  - 디폴트 계정: admin/admin
  - docker-compose.yml의 `SUPERVISOR_ADMIN_USERNAME`, `SUPERVISOR_ADMIN_PASSWORD`값으로 계정 수정 가능

### 1. Contest/Task 등록

[docs](./docs) 디렉토리의 참고자료 및 [CMS 공식 문서](https://cms.readthedocs.io/en/v1.4/index.html)를 참고하여
Contest를 생성하고 Task를 등록합니다.

### 2. Contest 실행

Admin 페이지에서 Contest를 등록한 후, `contest-list` 명령어로 Contest의 ID를 확인하고,
`run-contest <ID>`로 Contest를 실행합니다.

```sh
contest-list
# ID: 1 -  Name: test  -  Description: test
# ID: 2 -  Name: test2  -  Description: test2
run-contest 1
```

- `http://localhost:8888`로 Contest에 접속합니다.

### (+) 유저 등록 및 컨테스트 참가 자동화

유저를 자동으로 등록하려면 `add-user` 커맨드를 사용합니다.

```sh
# add_user <first name> <last name> <username> <password>
add-user Gyeongjae Choi ryanking13 pa55w0rd
```

유저를 특정 Contest에 참가시키려면 `add-participation` 커맨드를 사용합니다.

```sh
# add-participation <username> <contest ID>
add-participation ryanking13 1
```

_[examples](./examples) 디렉토리의 예시를 참고하세요._

## See also

- [cms](http://cms-dev.github.io/): 공식 CMS 웹사이트
- [cms-docker](https://github.com/algorithm-ninja/cms-docker): CMS 도커 스크립트 구버전
- [cms-guide](https://github.com/ryanking13/cms-guide): CMS 사용 팁


## TODO

- Nginx
- Scoreboard
- Randomize default password