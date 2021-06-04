import xlsx from "../models";

const seen = new Set();
const DeleteDuplicate = async(source:xlsx[], filter:string, keys:any ) => {
    const data = await source/* .reduce((acc:any,item:any)=>{
        if(!seen.has(item[filter])){
          seen.add(item[filter])
          acc.push(item)
        }
        return acc;
      },[]) */.filter((el:any) => {
        const duplicate = seen.has(el[filter]);
        seen.add(el[filter]);
        return !duplicate;
    }).map((item:any) => {
        let result:any = {};
        for (const elem of keys) {
            result[elem.db] =item[elem.xlsx];
        };
        return result;
    })
    return data;
};

export default DeleteDuplicate;