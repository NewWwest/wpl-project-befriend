import React from 'react';

function InterestList({interests}){
  return (<>
    <div>
      <h5>Hobbies:</h5>
      <ul>
      {
        interests && interests.length !== 0 ?
        interests.map((x, i) =>
          <li key={i} className="row col-12 m-1">
              <span className='bg-light mr-2 col-6 col-md-3 col-lg-2'>{x.name}</span>
          </li>
        )
        : <>
        <p>No hobbies yet.</p>
        </>
      }
      </ul>
    </div>
  </>
  );
}

export default InterestList;





