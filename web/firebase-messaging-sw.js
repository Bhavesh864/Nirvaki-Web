importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");


const firebaseConfig = {
    apiKey: "AIzaSyAw1c1ZWMUmGZHk7crsEOxm8ZDb9vAFwR0",
    authDomain: "brokr-in.firebaseapp.com",
    projectId: "brokr-in",
    storageBucket: "brokr-in.appspot.com",
    messagingSenderId: "868897852943",
    appId: "1:868897852943:web:45a680dc31050803979d7a",
    measurementId: "G-4G43D3Z8FK"
  };
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  
  console.log("onBackgroundMessage", message);
});