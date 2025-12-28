import { NavLink, Outlet } from "react-router-dom";


export default function TaskPage() {
  const pages = [1, 2, 3, 4];

  return (
    <div className="flex gap-2">
        <div className='flex flex-col gap-2'>
        {pages.map((page) => (
            <NavLink 
            key={page} 
            to={`/todo/${page}`}
            className={({ isActive })=>{
                return isActive ? 'text-primary-700': '';
            }}
            >
                Page {page}
            </NavLink>
        ))}
        </div>
        <Outlet />
    </div>
  );
}