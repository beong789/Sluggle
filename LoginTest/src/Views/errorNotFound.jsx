import { Link } from "react-router-dom";
export default function ErrorPage()
{
    return(
        <div className="flex flex-col gap-2">
            Error No Page found <br />
            <Link to="/"> login from Link</Link> <br />
        </div>
    )
}