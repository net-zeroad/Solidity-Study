![header](https://capsule-render.vercel.app/api?type=waving&color=gradient&height=300&section=header&text=Test-Token&fontAlignY=40&fontSize=100&desc=&descAlignY=65&animation=twinkling)

- blockchain7 수업 89일차
<br/><br/>


# 간단한 토큰 구현
- 토큰은 Ethereum 기반으로 만들어졌다.
  - ERC20, ERC721, ERC1155 : 대표적으로 많이 알려진 토큰이다.
    - ERC20(FT)    : 표준 토큰이다.
    - ERC721(NFT)  : 하나의 NFT는 하나의 소유자를 갖는다.
    - ERC1155(NFT) : 하나의 NFT는 다수의 소유자를 갖는다.
  - 이외로 ERC223, ERC621, ERC777 등이 있다.
- FT / NFT
  - FT : Fungible Token(대체 가능한 토큰)
  - NFT : Non Fungible Token(대체 불가능한 토큰)
- 가장 기본적인 토큰은 ERC20이라고 한다.
  - Ethereum Request for Comment 20
  - 이더리움 블록체인 네트워크에서 정한 표준 토큰
  - 스마트 컨트랙트로 생성한다.
- 아래의 코드는 내용을 최소화하여 완벽히 작동되지는 않는다.
    ```s
    contract TestToken {
        mapping(address => uint256) public balances;
        string public name;
        string public symbol;
        uint8 public decimals;
        uint public totalSupply;
    }
    ```
- balances    : 각 지갑 계정에 대한 잔액
- name        : 토큰 이름(Ether)
- symbol      : 토큰 단위(ETH)
- decimals    : 소수점의 개수(10의 -몇승인가?, wei와 ether의 관계..)
- totalSupply : 총 발행량
<br/><br/>

### TestToken.sol balanceOf(계좌)
    ```s
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    ```
- view : 함수에서 변수를 호출하지만 수정하지 못한다.(js의 const 변수같은 느낌)
<br/><br/>

### transfer(받는사람, 값) 잔액 보내기
```s
    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balances[msg.sender] >= _value);
        // 문제가 없을 시 트랜잭션을 보낸 사람에게서 value만큼 돈을 뺀다.
        balances[msg.sender] -= _value;
        // to, 즉 받는 사람에게 value만큼 돈을 더한다.
        balances[_to] += _value;
        return true;
    }
```
- require : 조건을 확인하여 에러를 발생하거나 코드를 계속 진행하는 역할을 한다.
  - 첫 번째 매개변수에 조건을 전달하며 true면 계속 진행, false면 중단한다.
  - 두 번째 매개변수로 에러 발생시 출력할 로그를 전달한다.
<br/><br/>



# 기본 폴더 및 라이브러리 세팅
```bash
cd projectFolder
npm init -y
npm i truffle
npm i -D prettier-plugin-solidity
npx truffle init
truffle-config.js Ganache Network development 주석 해제
```
<br/><br/>


# 프로젝트 기본 세팅
1. Ganache 네트워크에 배포(migration)해야 하므로 migration이전에 Ganache네트워크를 실행한다. (중요)
```bash
source ~/.bashrc
ganache
```
<br/><br/>

# 코드 작성, 컴파일 및 배포
1. /contracts/TestToken.sol 스마트 컨트랙트 코드 작성
```s
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TestToken {
    mapping(address => uint256) public balances;
    string public name = "dog";
    string public symbol = "DG";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000 * 10 ** decimals; // 1000 DG

    constructor(string memory _symbol) {
        balances[msg.sender] = totalSupply;
        symbol = _symbol;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;

        balances[_to] += _value;
        return true;
    }
}

```
- npx truffle compile -> build
<br/>

2. /migrations/1_deploy_TestToken.js 배포 코드 작성
```js
const TestToken = artifacts.require("TestToken.sol");

module.exports = function (deployer) {
    deployer.deploy(TestToken, "DG");
}
```
- npx truffle migration -> CA(0xf935712e813a3F94f940377b6f2aC7202657582c)
<br/><br/>

# 메서드 테스트
1. 아래 명령어를 통하여 .sol에 개발한 메서드를 테스트해볼 수 있다.
```bash
npx truffle console
truffle(development)> TestToken
truffle(development)> TestToken.sourcePath
```
<br/><br/>

# 토큰 테스트
- 배포 시 출력된 CA를 통하여 Metamask 에서 해당 토큰을 확인하여 볼 수 있다.
- CA(0xf935712e813a3F94f940377b6f2aC7202657582c)
- Metamask 확장 프로그램의 Ganache 네트워크에 접속한 후,
  자산 카테고리에서 토큰 가져오기를 클릭한다.
  이후 토큰 계약 주소에 해당 CA 주소를 입력하게 되면
  Metamask가 자동으로 인식하여 토큰 기호와 토큰 소수점을 입력하여 준다.
  -> 토큰 기호 : DG, 토큰 소수점 : 18 이 출력된다.
<br/><br/>




![footer](https://capsule-render.vercel.app/api?section=footer&type=waving&color=e2e4e3&height=130)