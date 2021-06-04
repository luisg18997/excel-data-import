import XLSX from 'xlsx';
import util from 'util';
import DeleteDuplicate from '../helpers/deleteDuplicate';
import xlsx from '../models';
import Query from '../services/pgQuery';

export const ImportData = async(document:any) => {
    try {
        const wb = await XLSX.read(document.data, {type:'buffer', cellDates: true});
        const data:xlsx[] = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
        const categoriesPrev = await DeleteDuplicate(data,"Category", [{db:"category",xlsx: "Category"}]);
        const subCategoriesPrev = await DeleteDuplicate(data, "Sub-Category",[{db:"category",xlsx: "Category"}, {db: "subCategory", xlsx: "Sub-Category"}]);
        let customersPrev = await DeleteDuplicate(data, "Customer ID", [{db: "code", xlsx:"Customer ID"},{db:"name", xlsx:"Customer Name"},{db:"segment", xlsx: "Segment"}]);
        customersPrev = customersPrev.map((item:any) => (
           {
            ...item,
            name: item.name.replace(/'/g, ''),
            }
        ));
        const statesPrev = await DeleteDuplicate(data,"State", [{db:"state",xlsx: "State"},{db:"region",xlsx: "Region"}]);
        const citiesPrev = await DeleteDuplicate(data,"City", [{db:"state",xlsx: "State"},{db:"city",xlsx: "City"}, {db:"postal_code",xlsx: "Postal Code"}]);
        let productsPrev = await DeleteDuplicate(data, "Product ID",[{db: "code", xlsx: "Product ID"}, {db:"category",xlsx: "Category"}, {db: "subCategory", xlsx: "Sub-Category"}, {db: "name", xlsx: "Product Name"}]);
        productsPrev = productsPrev.map((item:any) => (
            {
             ...item,
             name: item.name.replace(/'/g, ''),
             }
         ));
        const ordersPrev = await DeleteDuplicate(data, "Order ID", [{db: "code", xlsx: "Order ID"},{db: "customer", xlsx:"Customer ID"}, {db: "order_date", xlsx: "Order Date"}, {db: "ship_date", xlsx: "Ship Date"}, {db: "ship_mode", xlsx: "Ship Mode"}, {db:"state",xlsx: "State"},{db:"city",xlsx: "City"}])
        const orderProductsPrev =  await data.map((val:any) => (
            {
                order: val["Order ID"],
                product: val["Product ID"],
                sales: val.Sales,
                quantity: val.Quantity,
                discount: val.Discount,
                profit: val.Profit
            }
        ))
        console.table({numCat:categoriesPrev.length, numSubCat:subCategoriesPrev.length, numCus: customersPrev.length, numSta: statesPrev.length, numCit: citiesPrev.length, numPro: productsPrev.length, numOrd: ordersPrev.length, numOrPr: orderProductsPrev.length} );

        await Query(util.format("SELECT import_data.add_category_subCategory('%s'::JSONB, '%s'::JSONB) as result;", JSON.stringify(categoriesPrev), JSON.stringify(subCategoriesPrev)));
        await Query(util.format("SELECT import_data.add_state('%s'::JSONB) as result;", JSON.stringify(statesPrev)));
        await Query(util.format("SELECT import_data.add_city('%s'::JSONB) as result;", JSON.stringify(citiesPrev)));
        await Query(util.format("SELECT import_data.add_customer('%s'::JSONB) as result;", JSON.stringify(customersPrev)));
        await Query(util.format("SELECT import_data.add_product('%s'::JSONB) as result;", JSON.stringify(productsPrev)));
        await Query(util.format("SELECT import_data.add_order('%s'::JSONB) as result;", JSON.stringify(ordersPrev)));
        await Query(util.format("SELECT import_data.add_order_product('%s'::JSONB) as result;", JSON.stringify(orderProductsPrev)));
        
    

        return true;
    } catch (error) {
        throw error;
    };
}

export const getOrder = async(code:String) => {
    try {
        const order = await Query(util.format("SELECT import_data.get_data_by_order('%s') as result;", code));
        return order[0].result;
    } catch (error) {
        throw error;
    }
}

export const getOrders = async() => {
    try {
        const orders = await Query(util.format("SELECT import_data.get_all_data_by_order() as result;",));
        return orders[0].result;
    } catch (error) {
        throw error;
    }
}

export const getCustomer = async(code:String) => {
    try {
        const customer = await Query(util.format("SELECT import_data.get_data_by_customer('%s') as result;", code));
        return customer[0].result;
    } catch (error) {
        throw error;
    }
}