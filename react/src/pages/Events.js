import { React } from "react";
import { observer } from "mobx-react";
import { Link } from "react-router-dom";

function EventsComponent(eventsContext){
  eventsContext.getEvents()
  const renderEvent = (e, i) =>{
    return <Link key={i} to={`/event/${encodeURIComponent(e.ID)}`} className="card">
      <div className="card-body">
        <div className="card-title">
          <h5 className="d-inline">{e.name}</h5>
          {
              !e.subscribed ? "" : <span className="d-inline float-right">Subscribed!</span>
          }
          <small className="card-title d-inline m-1"> {e.schedule} </small>
        </div>
        <p className="card-text">{e.shortDescription}</p>
      </div>
    </Link>
  }

  return (
    <div>
      <div className="form-check">
        <input className="form-check-input" id="Showonlysubscribed" type="checkbox" value={eventsContext.showOnlySubscribed} onChange={()=>eventsContext.eventsFilter(!eventsContext.showOnlySubscribed)}/>
        <label className="form-check-label" htmlFor="Showonlysubscribed">
        Show only subscribed
        </label>
      </div>
    {
        !eventsContext.events ? <>There are no events available at the moment {eventsContext.events}</> : eventsContext.events.map((e,i)=>renderEvent(e,i))
    }
    </div>
  );
}

const Events = observer(({ eventsContext }) => EventsComponent(eventsContext))
export default Events;