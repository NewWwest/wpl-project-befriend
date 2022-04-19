import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
// note that the standard importing CSS using: import 'bootstrap/dist/css/bootstrap.min.css'; did not work

ReactDOM.render(
  <React.StrictMode>
    <link rel="stylesheet" href="http://localhost:8080/befriend/stylesheets/bootstrap.min.css" ></link>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);

reportWebVitals();
