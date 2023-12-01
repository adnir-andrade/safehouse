export default function Card({ title = "", children }) {
  return (
    <div className="card w-96 bg-neutral text-neutral-content">
      <div className="card-body items-center text-center">
        <h2 className="card-title">{title}</h2>
        {children}
      </div>
    </div>
  );
}
