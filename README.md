![header](https://capsule-render.vercel.app/api?type=waving&color=gradient&height=300&section=header&text=Solidity-Study&fontAlignY=40&fontSize=100&desc=&descAlignY=65&animation=twinkling)

# Solidity란?
- 스마트 컨트랙트 프로그래밍 언어로, 컴파일하여 *ByteCode를 생성한다.
- ByteCode : 트랜잭션의 data로 저장되며, 스마트 컨트랙트 실행 시 사용된다.
<br/><br/>

# Solidity Prettier 설정방법
0. solidity 확장 프로그램 설치(검정색 버전)
1. solidity 확장 프로그램의 settings.json 에서 아래의 설정을 해주어야 함
   `"prettier.documentSelectors": ["**/*.sol"]`
2. 프로젝트에 플러그인 설치
   `npm i -D prettier-plugin-solidity`
<br/><br/>


# Solidity 코드를 컴파일하는 방법
1. solc 라이브러리 설치
   `npm i solc`
2. 컴파일 명령어 실행
   `npx solc --bin --abi ./test.sol`
<br/><br/>


# Solidity의 자료형
https://merrily-code.tistory.com/97
<br/><br/>


# Solidity의 개념 - 컨트랙트
- 솔리디티 코드는 컨트랙트 안에 싸여 있다.
- 컨트랙트는 이더리움 애플리케이션의 기본적인 구성 요소이다.
  모든 변수와 함수는 어느 한 컨트랙트에 속한다.
- 컨트랙트는 우리의 모든 프로젝트의 시작 지점이라고 할 수 있다.
- 아래는 비어 있는 HelloWorld 컨트랙트이다.
```
	contract HelloWorld {

	}
```
<br/><br/>


# Solidity의 개념 - License
- 컨트랙트 파일에서 라이선스 표기는 필수라고 한다.
- 최상단에 어떤 라이센스를 사용하는지 적어준다.
	`// SPDX-License-Identifier: MIT`
<br/><br/>


# Solidity의 개념 - Version Pragma
- 모든 솔리디티 소스 코드(컨트랙트)는 version pragma로 시작해야 한다.
  이는 해당 코드가 이용해야 하는 솔리디티 버전을 선언하는 것이다.
  이를 통해 이후에 새로운 컴파일러 버전이 나와도 기존 코드가 깨지지 않도록 예방한다.
- Version Pragma를 선언하는 방법
	`pragma solidity ^0.8.15;`

<br/><br/>


# Solidity의 개념 - 변수
- 솔리디티의 상태 변수는 컨트랙트 저장소(이더리움 블록체인)에 영구적으로 저장되게 된다.
- 컨트랙트의 상태변수는 데이터베이스에 데이터를 쓰는 것과 동일하다고 생각하면 된다.
- 변수 선언 방법
`uint myInteger = 100;`
`string name;`

- 타입의 종류 : 웬만하면 uint를 사용한다.
  int(int256), uint(uint256), uint8, uint16, uint32와 같이 uint를 더 적은 비트로 선언할 수도 있다.
<br/><br/>


# Solidity의 개념 - 구조체
- 좀 더 복잡한(여러 특성을 가진) 컨트랙트 코드를 작성하기 위해 구조체를 사용할 수 있다.
- 구조체를 선언하는 방법
```
	struct Person {
	    uint age;
	    string name;
	}
```
<br/><br/>


# Solidity의 개념 - 배열
- 솔리디티에는 정적 배열과 동적 배열이라는 두 종류의 배열이 있다.
- 상태 변수가 블록체인에 영구적으로 저장되는 것처럼 구조체의 동적 배열을 생성하면
  마치 데이터베이스처럼 컨트랙트에 구조화된 데이터를 저장하는 데 유용하다.
- 배열을 public으로 선언하여 주면 해당 배열을 다른 앱에 보여지게 할 수 있다.
- 정적 배열(고정 길이의 배열)은 아래의 형태로 배열의 길이를 지정할 수 있다.
	`uint[2] fixedArray;`
	`string[5] stringArray;`

- 동적 배열 : 고정된 크기가 없으며 계속 크기가 커질 수 있다.
	`uint[] dynamicArray;`
- 구조체의 배열(동적배열) : 구조체의 배열을 생성할 수도 있다. 데이터베이스처럼 활용될 수 있다.
	`Person[] people;`
- public 배열 : public으로 배열을 선언할 수 있으며 솔리디티는 이런 배열을 위해 getter 메소드를 자동 생성해준다.
	`Person[] public people;`
<br/><br/>


# Solidity의 개념 - 구조체와 배열의 활용
- 구조체를 이용하여 새로운 구조체 변수(?)를 생성한다.
	`Person satoshi = Person(172, "Satoshi");`
- 생성된 구조체 변수(?)를 배열에 추가한다.
	`people.push(satoshi);`
- 위 두 내용을 아래와 같이 한 줄로 표현할 수도 있다.
	`people.push(Person(16, "Vitalik"));`
<br/><br/>


# Solidity의 개념 - 함수
- 솔리디티에서의 public 함수 선언(2개의 인자(string, uint)를 전달받고 있다.)
```
	function eatHamburgers(string _name, uint _amount) {
	    // 함수의 내용은 비어있다.
	}
```
- 함수의 인자(매개변수)는 언더스코어(_)로 시작해서 전역변수와 구별하는 것이 관례이다.
- 선언한 함수의 호출 방법
	`eatHamburgers("vitalik", 100);`
- 솔리디티에서 함수는 기본적으로 public으로 선언되어, 누구나 나의 컨트랙트 함수를 호출하고 
  코드를 실행할 수 있다. 이는 나의 컨트랙트를 공격에 취약하게 만들 수 있기에 기본적으로 
  함수를 private으로 선언하고, 공개할 함수만 public으로 바꿔주는 것이 좋다.
- private 키워드는 함수명(인자) 다음에 적는다. 또한 private 함수명도 언더바(_)로 시작하는 것이 관례이다.
- 함수를 private으로 선언(1개의 인자(uint)를 전달받고 있다.)
```
	function _addToArray(uint _number) private {
	    // 함수의 내용은 비어있다.
	}
```
<br/><br/>


# Solidity의 개념 - 함수의 반환값(returns (string)) 및 함수 제어자(view, pure 등)
- 함수에서 어떤 값을 반환 받으려면 다음과 같이 선언해야 한다. (returns (string))
```
	function sayHello() public returns (string) {
 	   return "What's up dog";
	}
```
- 위처럼 솔리디티에서의 함수 선언은 반환값 종류(string)를 포함한다.
- 또한 위의 함수는 솔리디티에서 상태를 변화(어떤값을 변경 혹은 쓰는행위)시키지 않는다.
  이러한 경우에는 함수를 view 함수(데이터를 보기만 하고 변경하지 않는다는 뜻)로 선언한다.
	`function sayHello() public view returns (string) {`
- 또한 솔리디티는 pure 함수(앱에서 어떤 데이터도 접근하지 않는다는 뜻)도 가지고 있다.
```
	function _multiply(uint a, uint b) private pure returns (uint) {
 	   return a * b;
	}
```
- pure 함수는 읽는 것도 하지 않고 단지 함수에 전달된 인자값에 따라 반환값이 달라진다.
<br/><br/>


# Solidity의 개념 - keccak256
- 이더리움은 SHA3(해시 함수)의 한 버전인 keccak256를 내장 함수로 가지고 있다.
  해시 함수는 기본적으로 입력 스트링을 랜덤 256비트 16진수로 매핑한다.
- 아래와 같이 문자열을 16진수로 해싱할 수 있다
```
	//6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
	keccak256("aaaab");
```
<br/><br/>


# Solidity의 개념 - 형변환
- string인 변수(숫자이긴 해야함, 아래는 16진수 해시값)를 아래와 같이 uint 형식으로 변환할 수 있다.
	`uint(keccak256("aaaab"));`
<br/><br/>


# Solidity의 개념 - 이벤트
- 이벤트는 나의 컨트랙트가 블록체인 상에서 앱에 사용자의 액션이 생겼을때 의사소통 하는 방법이다.
- 컨트랙트는 특정 이벤트가 일어나는지 귀 기울이고, 이벤트가 발생하면 행동을 취해야 한다.
- 이벤트 선언
	`event IntegersAdded(uint x, uint y, uint result);`
- 이벤트 실행
```
	function add(uint _x, uint _y) public {
	    uint result = _x + _y;

	    // 함수 내에서 아래와 같이 이벤트를 실행하여 앱에게 add 함수가 실행되었음을 알린다
 	   IntegersAdded(_x, _y, result);
	   
 	   return result;
	}
```
<br/><br/>


# Solidity의 개념 - 주소
- 이더리움 블록체인은 은행 계좌와 같은 계정들로 이루어져 있다. 계정은 이더리움 블록체인 상의 
  통화인 Ether의 잔액을 가지며 다른 계정과 이더를 주고받을 수 있다.
- 각각의 계정은 은행 계좌 번호(고유 식별자)와 같은 주소를 가지고 있다. 
- 표현된 크립토 좀비 팀의 주소 : 0x0cE446255506E92DF41614C46F1d6df9Cc969183
<br/><br/>



# Solidity의 개념 - 매핑
- 매핑 및 주소 자료형을 알면 데이터베이스에 저장된 좀비에 주인을 설정할 수 있다.
- 매핑은 솔리디티에서 구조체나 배열과 같이 구조화된 데이터를 저장하는 또 다른 방법이다.
- 매핑을 정의하는 방법
```
	// 유저의 계좌 잔액을 보유하는 uint를 저장한다.(address : key, uint : value)
	mapping (address => uint) public accountBalance;
	// userId로 유저 이름을 저장하는 데 매핑을 사용한다.
	mapping (uint => string) userIdToName;
```
- 매핑은 기본적으로 key-value 저장소이며 데이터를 저장 및 검색하는 데 이용된다.
<br/><br/>



![footer](https://capsule-render.vercel.app/api?section=footer&type=waving&color=e2e4e3&height=130)
