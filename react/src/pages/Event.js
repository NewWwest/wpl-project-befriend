import { React } from "react";
import { useParams } from "react-router-dom";
import { observer } from "mobx-react";

function EventComponent(eventsContext){
  let { id } = useParams();
  const ed = eventsContext.getEventDetails(id);
  

  const renderEventDetails = (eventDetails)=>{
  var closeSubscribtionsDate = new Date(ed.closeSubscribtionsDate);
  const showSubscribe = !eventDetails.subscribed && closeSubscribtionsDate > new Date();

    return <div className="card">
        <div className="card-body">
          <div className="card-title">
            <h5 className="d-inline">{eventDetails.name}</h5>
            {
              showSubscribe ? 
              <button className="btn btn-primary d-inline-block ml-2 float-right" onClick={()=>eventsContext.changeSubscription(true, eventDetails.ID)}> Subscribe</button>
              :
              <button className="btn btn-warning d-inline-block ml-2 float-right" onClick={()=>eventsContext.changeSubscription(false, eventDetails.ID)}> Unsubscribe</button>
            }
            <small className="card-title d-inline m-1 float-right"> {eventDetails.schedule} </small>
          </div>
          <p className="card-text">{eventDetails.description}</p>
        </div>
      </div>
  }

  return (
    <>
    {ed ? renderEventDetails(ed) : ""}
    </>
  );
}






const Event = observer(({ eventsContext }) => EventComponent(eventsContext))
export default Event;