import { React, useState } from "react";
import Select from 'react-select'


function InterestPicker({context}){
  const [showNewInterestForm, setShowNewInterestForm] = useState(false);

  context.getInterest();
  return (<>
  <div>
  <label className='row'>
        <Select className="col-10 col-md-4 col-lg-3" 
        noOptionsMessage={() => "Can't see your hoobby? Add one bellow!"}
        options={context.interestList} 
        onChange={(evt)=>{context.selectedInterest = evt.value}}/>
    <button  className="col-2 col-md-1 col-lg-1 btn btn-primary"  onClick={()=>context.addInterest(context.selectedInterest)}>Add</button>
  </label>
  </div>
  <div>
    {showNewInterestForm ? "" :
      <div> <button onClick={() => {setShowNewInterestForm(true)}} className="btn btn-primary m-1">Can't see your hoobby? Add one!</button></div>
    }
    {
      !showNewInterestForm ? "" :<div className="row">
      <div className="col-10 col-md-4 col-lg-3 pr-4" >
        <input className="col-12" type="text" name="interest" value={context.newInterest} onChange={(e) => {context.newInterest = e.target.value}}/>
      </div>
        <button className="col-2 col-md-1 col-lg-1 btn btn-primary" onClick={()=>context.createInterest(context.newInterest) }>Create new Interest</button>
      </div>

    }
  </div>
  </>
  );
}

export default InterestPicker;





