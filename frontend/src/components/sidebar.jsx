import { useState } from "react";

export default function Sidebar({ children }) {
  const [isChecked, setIsChecked] = useState(false);

  function changeState() {
    setIsChecked(!isChecked);
  }

  return (
    <div className="drawer lg:drawer-open">
      <input
        id="sidebar"
        type="checkbox"
        className="drawer-toggle"
        checked={isChecked}
      />
      <div className="drawer-content flex flex-col items-center justify-center">
        {children}
        <button className="btn" onClick={changeState}>
          Open Sidebar
        </button>
      </div>
      <div className="drawer-side">
        <label
          htmlFor="sidebar"
          aria-label="close sidebar"
          className="drawer-overlay"
          onClick={changeState}
        ></label>
        <ul className="menu p-4 w-80 min-h-full bg-base-200 text-base-content">
          {/* Sidebar content here */}
          <li>
            <a>Sidebar Item 1</a>
          </li>
          <li>
            <a>Sidebar Item 2</a>
          </li>
        </ul>
      </div>
    </div>
  );
}
