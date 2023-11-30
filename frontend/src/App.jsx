import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./index.css";
import Navbar from "./components/navbar";
import Sidebar from "./components/sidebar";

function App() {
  const [count, setCount] = useState(0);

  return (
    <>
      <Navbar />
      <Sidebar>
        <div className="flex flex-col w-full lg:flex-row">
          <div className="grid flex-grow h-32 card bg-base-300 rounded-box place-items-center">
            content
          </div>
          <div className="divider lg:divider-horizontal">OR</div>
          <div className="grid flex-grow h-32 card bg-base-300 rounded-box place-items-center">
            content
          </div>
        </div>
      </Sidebar>
    </>
  );
}

export default App;
