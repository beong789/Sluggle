import { useParams } from "react-router-dom"

export default function TaskPage()
{   
    const param = useParams();
    return(
        <div>
            Task {param.pageId}
        </div>
    )
}