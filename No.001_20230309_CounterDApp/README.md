![header](https://capsule-render.vercel.app/api?type=waving&color=gradient&height=300&section=header&text=Solidity-Counter&fontAlignY=40&fontSize=100&desc=&descAlignY=65&animation=twinkling)


- blockchain7 수업 88일차
<br/><br/>

# 기본 폴더 및 라이브러리 세팅
```bash
cd projectFolder
yarn create react-app front
cd front
yarn add axios web3
cd ..
mkdir back
cd back
npm init -y
npm i truffle express cors web3
npm i prettier-plugin-solidity
npx truffle init
```
<br/><br/>

# 프로젝트 기본 세팅
1. ubuntu에서 ganache 실행
```bash
source ~/.bashrc
ganache
```
2. 메타마스크 확장 프로그램 가나슈 네트워크 연결 및 private key를 통하여 계정 가져오기
3. /back/truffle-config.js 67~71 주석 해제
```js
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 8545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },
```
4. /front/src/index.js StrictMode 해제
```js
root.render(
  // <React.StrictMode>
  <App />
  // </React.StrictMode>
);
```
5. git에 commit할 예정이라면 최상위 폴더의 .gitignore에 node_modules와 build 추가
<br/><br/>

# 컨트랙트 개발 시작
1. /back/contracts 폴더에 Counter.sol 파일 생성 및 아래와 같이 코드 작성
```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Counter {
    int256 private count;

    event Count(int256 count);

    constructor() {
        count = 0;
    }

    function getCount() public view returns (int256) {
        return count;
    }

    function increment() public {
        count += 1;
        emit Count(count);
    }

    function decrement() public {
        count -= 1;
        emit Count(count);
    }
}
```
## 위 코드 설명
- 라이센스를 기본으로 입력하여 준다.
`// SPDX-License-Identifier: MIT` 
- 솔리디티 버전을 설정하여 준다.
`pragma solidity ^0.8.18;`
- Counter라는 컨트랙트(계약서)를 생성한다. `contract Counter {}`
- count라는 private int 변수 생성 `int256 private count;`
- Count라는 event 생성 `event Count(int256 count);`
  - event에서 매개변수는 뭐 하는 놈이더라..
  - 이벤트를 감지하면 어디에 뭐가 출력되는지 다시 확인해보기..
- 생성자를 통하여 변수에 값 할당 `constructor() {}`
- `function getCount()` : 컨트랙트 내부의 count 변수의 값을 리턴하는 함수이다.
- `function increment()` : 컨트랙트 내부의 count 값을 1 올리고 count가 변하였음을 알리는 함수이다.
- 이후 `npx truffle compile`을 통하여 해당 .sol파일을 compile하면 build 폴더 및 json이 생성된다.
<br/><br/>

# CounterContract 배포 시작
1. /back/migration 폴더에 1_deploy_Counter.js 파일 생성 및 코드 작성
```js
const Counter = artifacts.require("Counter");

module.exports = function (deployer) {
  deployer.deploy(Counter);
};
```
## 위 코드 설명
const Counter = artifacts.require("Counter");
- 만들어진 Counter 컨트랙트를 가져온다. `artifacts.require("Counter")`
- `function(deployer){}` : 배포를 위한 기본 함수 틀이다. migration시 알아서 이 함수에 매개변수를 넣는다.
- Counter 컨트랙트를 배포한다. `deployer.deploy(Counter);`
- `module.exports` : 해당 함수를 export하여 migration시 해당 함수를 인식할 수 있게 한다.
- 이후에 `npx truffle migration`을 통하여 블록체인 네트워크에 해당 컨트랙트를 배포할 수 있다. 
<br/><br/>


# 스마트 컨트랙트 컴파일 및 네트워크 배포(truffle)
- back 폴더 경로에서 아래 명령어를 실행하면 된다.
- 컴파일 : `npx truffle compile`
  - /back 폴더에 build 폴더와 컴파일된 json 파일이 함께 생성된다. 
- 배포 : `npx truffle migration`
  - 트랜잭션 해시, CA 등이 출력된다.(이미지)
  - 해당 네트워크에도 같은 로그가 츨력된다.
<br/><br/>


# front에서 배포된 스마트 컨트랙트 메서드 접근
1. /front/src 폴더에 useWeb3.js 파일 생성 및 아래 코드 작성
- 현재 접속된 account와 web3를 리턴하는 커스텀 훅
```js
import { useState, useEffect } from "react";
import Web3 from "web3";

const useWeb3 = () => {
  const [web3, setWeb3] = useState();
  const [account, setAccount] = useState();

  useEffect(() => {
    (async () => {
      if (!window.ethereum) return;
      // 메타마스크가 설치되지 않았으면 끝내라.

      const [address] = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      setAccount(address);

      const _web3 = new Web3(window.ethereum);
      setWeb3(_web3);
      // 메타마스크와 연결
    })();
    // (함수)() : 즉시실행함수, 함수를 바로 실행한다.
  }, []);

  return [web3, account];
};
// 컴포넌트가 아니다 => 커스텀훅, Custom Hook : 보통 앞에 use를 붙인다.

export default useWeb3;
```
<br/>

2. /front/src 폴더에 Counter를 출력하기 위한 Counter.jsx 파일 생성 및 아래 코드 작성
```js
import { useState, useEffect, useCallback } from "react";
import axios from "axios";

const Counter = ({ web3, account }) => {
    const [count, setCount] = useState(0);

    const getCount = useCallback(async () => {
        const _count = (await axios.post("http://localhost:8080/api/count")).data
            .count;
        setCount(_count);
    }, []);

    useEffect(() => {
        getCount();
        (async () => {
            const { CA } = (await axios.post("http://localhost:8080/api/ca")).data;
            web3.eth.subscribe("logs", { address: CA }).on("data", (log) => {
                const params = [{ type: "int256", name: "count" }];
                const value = web3.eth.abi.decodeLog(params, log.data);
                setCount(value.count);
            });
        })();
    }, []);

    const increment = async () => {
        const data = (
            await axios.post("http://localhost:8080/api/increment", { from: account })
        ).data;
        await web3.eth.sendTransaction(data);
    };

    const decrement = async () => {
        const data = (
            await axios.post("http://localhost:8080/api/decrement", { from: account })
        ).data;
        await web3.eth.sendTransaction(data);
    };

    return (
        <div>
            <h2>Count : {count}</h2>
            <button onClick={() =>{ increment() }}>+</button>
            <button onClick={() =>{ decrement() }}>-</button>
        </div>
    );
};

export default Counter;
```
<br/>

3. /front/src/App.js 파일 아래와 같이 수정
- 커스텀 훅을 불러오고 Counter Component를 출력하였다.
```js
import useWeb3 from "./useWeb3";
import Counter from "./Counter";

function App() {
  const [web3, account] = useWeb3();

  if (!account) return <h1>메타마스크 설치 및 계정 연결해줘</h1>;

  return (
    <div className="App">
      <h1>Account : {account}</h1>
      <Counter web3={web3} account={account} />
    </div>
  );
}

export default App;
```
<br/>

4. /back 폴더에 index.js 파일 생성 및 아래 코드 작성
- 요청에 대한 응답을 하기 위함
```js
const express = require("express");
const cors = require("cors");
const Web3 = require("web3");
const CounterContract = require("./build/contracts/Counter.json");

const app = express();
const web3 = new Web3("http://127.0.0.1:8545");

app.use(cors({ origin: true, credentials: true }));
// origin : true => 모든 주소에 대해서 cors 허용
app.use(express.json());

app.use("/", async (req, res, next) => {
  const networkId = await web3.eth.net.getId();
  global.CA = CounterContract.networks[networkId].address;
  const abi = CounterContract.abi;

  global.deployed = new web3.eth.Contract(abi, global.CA);

  next();
});

app.post("/api/count", async (req, res) => {
  const count = await global.deployed.methods.getCount().call();
  res.json({ count });
});

app.post("/api/ca", async (req, res) => {
  res.json({ CA: global.CA });
});

app.post("/api/increment", async (req, res) => {
  const from = req.body.from;
  const nonce = await web3.eth.getTransactionCount(from);
  const data = await global.deployed.methods.increment().encodeABI();

  const txObj = {
    nonce,
    from,
    to: global.CA,
    data,
  };

  res.json(txObj);
});

app.post("/api/decrement", async (req, res) => {
  const from = req.body.from;
  const nonce = await web3.eth.getTransactionCount(from);
  const data = await global.deployed.methods.decrement().encodeABI();

  const txObj = {
    nonce,
    from,
    to: global.CA,
    data,
  };

  res.json(txObj);
});

app.listen(8080, () => {
  console.log("server start");
});
```
<br/><br/>

# 실행 및 확인하기
## 서버 실행
1. /back 폴더 경로 접근 및 `node index.js` 명렁어로 서버 실행
2. /front 폴더 경로 접근 및 `yarn start` 명령어로 프론트 서버 추가 실행
## 확인 
1. 3000포트 페이지에 접속하면 메타마스크 연결 확장 프로그램이 열립니다.
2. 가나슈 네트워크에 접속하면 연결된 지갑 주소 정보가 출력됩니다.
3. +버튼 혹은 -버튼을 누르면 메타마스크 확장 프로그램이 실행되며 트랜잭션을 보내 Count를 증감시킬 수 있으며 증감된 Count를 바로 확인할 수 있습니다.
<br/><br/>


# 스마트 컨트랙트의 메서드 실행 방법 이해하기
  - Counter.jsx 컴포넌트의 increment, decrement 함수 및 index.js의 axios 응답 부분을 참고하여 스마트 컨트랙트의 메서드 실행 방법을 이해할 수 있습니다.
    - increment 함수
    ```js
    const increment = async () => {
        const data = (await axios.post("http://localhost:8080/api/increment", { from: account })).data;
        await web3.eth.sendTransaction(data);
    };
    ```
    - index.js /api/increment 응답 
    ```js
    app.post("/api/increment", async (req, res) => {
        const from = req.body.from;
        const nonce = await web3.eth.getTransactionCount(from);
        const data = await global.deployed.methods.increment().encodeABI();

        const txObj = {
            nonce,
            from,
            to: global.CA,
            data,
        };

        res.json(txObj);
    });
    ```


![footer](https://capsule-render.vercel.app/api?section=footer&type=waving&color=e2e4e3&height=130)