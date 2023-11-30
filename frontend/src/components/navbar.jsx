export default function Navbar() {
  return (
    <div className="navbar bg-base-100">
      <div class="flex-none">
        <button
          htmlFor="my-drawer-2"
          class="btn btn-square btn-ghost drawer-button lg:hidden"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            class="inline-block w-5 h-5 stroke-current"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            ></path>
          </svg>
        </button>
      </div>
      <a className="btn btn-ghost text-xl">The Safehouse</a>
    </div>
  );
}
