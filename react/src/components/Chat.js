import {React, useState, useEffect  } from 'react';
import { observer } from "mobx-react";



function ChatComponent(context, user){
    const [newMessage, setNewMessage] = useState("");
    context.getMessages(user?.username);
    useEffect(() => {
      const interval = setInterval(() => {
        console.log("Checking for new messages");
        context.getMessages(user?.username, true);
      }, 30000);
    
      return () => clearInterval(interval); 
    }, [])


    
    const messageFromYou = (m,i) =>{
        return <div className="row w-100 m-1" key={i}>
          <div className="col-3">
          </div>
          <div className="border border-secondary rounded p-1 col-9">
            <div className="small">You wrote</div>
            <div>{m.content}</div>
          </div>
        </div>
    }
    const messageToYou = (m,i) => {
        return <div className="row w-100 m-1" key={i}>
          <div className="border border-secondary rounded p-1 col-9">
            <div className="small">{m.fromDisplayName} wrote:</div>
            <div>{m.content}</div>
          </div>
          <div className="col-3">
          </div>
        </div>
    }
    const renderMessage = (m,i)=>{
        if(m.from === context.username){
            return messageFromYou(m,i);
        }
        else{
            return messageToYou(m,i);
        }
    }
    const sendMessage = (evt)=>{
        evt.preventDefault();
        if(user){
          context.sendMessage(newMessage, user.username);
          setNewMessage("");
        }
    }
    
  return (
    <div className='col-12 p-5 '>
        <h5>Chat</h5>
        <div className='border border-secondary m-2 p-2 chat-window'>
            {context.messages && context.messages.length>0 ? context.messages.map((m,i)=>renderMessage(m,i)):<>No messages yet!</> }
        </div>

        <div className='row p-2'>
            <small className='mb-1'>New message:</small>
            <form className='col-12' onSubmit={sendMessage}>
            <input type="text" className='col-12 mb-1'  value={newMessage} onChange={(e) => {setNewMessage(e.target.value)}}></input>
            <input type="submit" value="Send" className='btn btn-primary'></input>
            </form>
        </div>
    </div>
  );
}

const Chat = observer(({ context, user }) => ChatComponent(context, user))
export default Chat;
