import React from 'react';


function About(){
  return (<>
    <div>
      <h2>About</h2>
      <p>The BeFriend project was created to simplify meeting new people. Especially when working or studying in a remote setting one simply lack the opportunity to create new contacts.</p>
      <p>BeFriend helps you to do that in two ways:</p>
      <div className="card">
        <div className="card-body">
          <h5 className="card-title">Friend matching</h5>
          <p className="card-text">On BeFriend you can browse people registerrred in the system. 
          If you both decide that you fit each other, you will receive the other persons contact information. 
          Just so you know: there is no limit on people you look through :)</p>
        </div>
      </div>
      <div className="card">
        <div className="card-body">
          <h5 className="card-title">Events</h5>
          <p className="card-text">On BeFriend you can look through events organized in your neighborhood. 
          Moreover some Events repeated periodically and once subscribed, you will be included in all events from that series!</p>
        </div>
      </div>
      <p>Project was created by Andrzej Westfalewicz for CS4275 Web Programming Languages course on TU Delft</p>
    </div>
  </>
  );
}

export default About;





