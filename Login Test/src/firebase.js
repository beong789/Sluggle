import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyCrNkgYr8-tzwNm__uVmvI1XOp7Z2NNazk",
  authDomain: "sluggle-98ed6.firebaseapp.com",
  projectId: "sluggle-98ed6",
  storageBucket: "sluggle-98ed6.firebasestorage.app",
  messagingSenderId: "265643232016",
  appId: "1:265643232016:web:9083a6402e4901e881f395",
  measurementId: "G-WTF195KE9R"
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const provider = new GoogleAuthProvider();
