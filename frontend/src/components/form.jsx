export default function Form() {
  return (
    <div>
      <form className="mb-5">
        <div className="form-control w-full max-w-xs">
          <label className="label">
            <span className="label-text text-gray-400">Nome</span>
          </label>
          <input
            type="text"
            placeholder="Rick Grimes"
            className="input input-bordered text-white w-full max-w-xs text-white"
            id="name"
            required
          />
        </div>
        <div className="form-control w-full max-w-xs">
          <label className="label">
            <span className="label-text text-gray-400">Idade</span>
          </label>
          <input
            type="number"
            min={1}
            max={120}
            placeholder={30}
            className="input input-bordered text-white w-full max-w-xs"
            id="age"
            required
          />
        </div>
        <div className="form-control w-full max-w-xs">
          <label className="label">
            <span className="label-text text-gray-400">Sexo</span>
          </label>
          <select
            className="select select-bordered text-white mb-4 text-gray-400"
            id="gender"
            required
          >
            <option disabled selected>
              Gênero
            </option>
            <option value="Female">Feminino</option>
            <option value="Male">Masculino</option>
          </select>
        </div>
        <p className="font-semibold">Ultima Posição</p>
        <div className="form-control w-full max-w-xs">
          <label className="label">
            <span className="label-text text-gray-400">Longitude</span>
          </label>
          <input
            type="number"
            min={-180.0}
            max={180.0}
            step="0.000001"
            placeholder={0.0}
            className="input input-bordered text-white w-full max-w-xs"
            id="longitude"
          />
        </div>
        <div className="form-control w-full max-w-xs">
          <label className="label">
            <span className="label-text text-gray-400">Latitude</span>
          </label>
          <input
            type="number"
            min={-90.0}
            max={90.0}
            step="0.000001"
            placeholder={0.0}
            className="input input-bordered text-white w-full max-w-xs"
            id="latitude"
          />
        </div>
        {/* Inventory will go here in future updates */}
        {/* <div class="inputs">
            <textarea name="inventario" id="itens" cols="30" rows="5"></textarea>
            </div> */}
      </form>
      <div className="card-actions">
        <button>Send</button>
      </div>
    </div>
  );
}
