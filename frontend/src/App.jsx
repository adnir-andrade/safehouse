import { useState } from "react";
import "./index.css";
import Navbar from "./components/navbar";
import Sidebar from "./components/sidebar";
import Card from "./components/card";
import Form from "./components/form";

function App() {
  const [isChecked, setIsChecked] = useState(false);

  function changeState() {
    console.log("Clicked");
    setIsChecked(!isChecked);
  }

  return (
    <>
      <Navbar onClick={changeState} />
      <Sidebar isChecked={isChecked} onClick={changeState}>
        <div className="flex flex-col h-4/5 lg:flex-row py-12">
          <div className="grid flex-grow card bg-base-300 rounded-box place-items-center">
            <Card title="Register New Survivor">
              <Form></Form>
            </Card>
          </div>
          <div className="divider lg:divider-horizontal">OR</div>
          <div className="grid flex-grow card bg-base-300 rounded-box place-items-center">
            content
          </div>
        </div>
      </Sidebar>
    </>
  );
}

export default App;
