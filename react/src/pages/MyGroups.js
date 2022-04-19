import { React } from "react";
import { observer } from "mobx-react";
import { Link } from "react-router-dom";

function MyGroupsComponent(eventsContext){
  eventsContext.getGroups();

  const renderGroup = (eg, i)=>{
    var d = new Date(eg.date)
    return <Link className="card" key={i} to={`/group/${encodeURIComponent(eg.ID)}`}>
      <div className="card-body">
        <div className="card-title">
          <h5 className="d-inline">{eg.name}</h5>
          <span className="d-inline float-right">{d.toLocaleDateString('en-US')}</span>
        </div>
        <p className="card-text">{eg.eventShortDescription}</p>
      </div>
    </Link>
  }

  var noGroups = eventsContext.groups == null || eventsContext.groups.length === 0;
  var filterEmpty = eventsContext.groupsSearchString == null || eventsContext.groupsSearchString === '';
  var groups = eventsContext.groups ? eventsContext.groups : [];
  var filterred = filterEmpty ? groups : groups.filter(eg=>eg.name?.toLowerCase().includes(eventsContext.groupsSearchString.toLowerCase()));

  return (
    <div>
      <div className="row m-1">
        <span className="col-4 col-sm-1">Filter:</span>
        <input 
          value={eventsContext.groupsSearchString} onChange={(e) => {eventsContext.groupsSearchString = e.target.value}}
          className="col-8 col-sm-11" type="text">
        </input>
      </div>
      {
      noGroups
      ?
      <div>You aren't a member of any group at the moment.</div>
      :
      ""
      }
      {
        !noGroups && filterred.length > 0 ? filterred.map((g,i)=>renderGroup(g,i)) : "No such groups"
      }
    </div>
  );
}


const MyGroups = observer(({ eventsContext }) => MyGroupsComponent(eventsContext))
export default MyGroups;