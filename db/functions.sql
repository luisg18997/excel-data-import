-- function of create category and subCategory

CREATE OR REPLACE FUNCTION import_data.add_category_subCategory(
    param_categories JSONB,
    param_subcategories JSONB
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        i json;
		j json;
		category_id INTEGER;
		insert_data INTEGER := 0;
    BEGIN
        FOR i IN SELECT * FROM jsonb_array_elements(param_categories)
		LOOP
			RAISE NOTICE 'Name category: %', i->'category';
			if NOT EXISTS(select name from import_data.categories where name = i->>'category')THEN
				INSERT INTO
					import_data.categories(name)
				VALUES
					(i->>'category')
				RETURNING id
				INTO STRICT category_id;
			ELSE 
			SELECT id from import_data.categories where name = i->>'category' INTO category_id;
			END IF;
			FOR j IN SELECT * FROM jsonb_array_elements(param_subcategories)
			LOOP
				if(j::jsonb @> i::jsonb) THEN
				RAISE NOTICE 'Name subcategory: %', j->'subCategory';
					IF NOT EXISTS(select name from import_data.subcategories where name = j->>'subCategory') THEN
						INSERT INTO
							import_data.subcategories(category_id,name)
						VALUES
                			(category_id, j->>'subCategory');
						GET DIAGNOSTICS insert_data = ROW_COUNT;
					END IF;
				END IF;
			END LOOP;
		END LOOP;
		RAISE NOTICE 'INSERT subcategory: %', insert_data;
		IF (insert_data != 0) THEN
			local_is_successful :='1';
		END IF;
        return local_is_successful;
    END;
$udf$;

-- function create city and state
CREATE OR REPLACE FUNCTION import_data.add_state(
    param_states JSONB
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        i json;
		insert_data INTEGER := 0;
    BEGIN
        FOR i IN SELECT * FROM jsonb_array_elements(param_states)
		LOOP
			RAISE NOTICE 'Name state: %', i->'state';
			if NOT EXISTS(select name from import_data.states where name = i->>'state')THEN
				INSERT INTO
					import_data.states(name, region)
				VALUES
					(i->>'state', i->>'region');
				GET DIAGNOSTICS insert_data = ROW_COUNT;
			END IF;
		END LOOP;
		RAISE NOTICE 'INSERT state: %', insert_data;
		IF (insert_data != 0) THEN
			local_is_successful :='1';
		END IF;
        return local_is_successful;
    END;
$udf$;

-- function city
CREATE OR REPLACE FUNCTION import_data.add_city(
    param_cities JSONB
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        i json;
		state_id INTEGER;
		insert_data INTEGER := 0;
    BEGIN
        FOR i IN SELECT * FROM jsonb_array_elements(param_cities)
		LOOP
			RAISE NOTICE 'Name city: %', i->'city';
			IF NOT EXISTS(select name from import_data.cities where name = i->>'city') THEN
				SELECT id INTO state_id FROM import_data.states where name = i->>'state';
				INSERT INTO
					import_data.cities(state_id,name, postal_code)
				VALUES
					(state_id, i->>'city', CAST(i->>'postal_code' as INTEGER));
				GET DIAGNOSTICS insert_data = ROW_COUNT;
			END IF;
		END LOOP;
		RAISE NOTICE 'INSERT customer: %', insert_data;
		IF (insert_data != 0) THEN
			local_is_successful :='1';
		END IF;
        return local_is_successful;
    END;
$udf$;

-- function of create customer
CREATE OR REPLACE FUNCTION import_data.add_customer(
    param_customers JSONB
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        i json;
		insert_data INTEGER := 0;
    BEGIN
        FOR i IN SELECT * FROM jsonb_array_elements(param_customers)
		LOOP
			RAISE NOTICE 'Name customer: %', i->'name';
			if NOT EXISTS(select name from import_data.customers where code = i->>'code')THEN
				INSERT INTO
					import_data.customers(code, name, segment)
				VALUES
					(i->>'code', i->>'name' , i->>'segment');
                GET DIAGNOSTICS insert_data = ROW_COUNT;
			END IF;
		END LOOP;
		RAISE NOTICE 'INSERT customer: %', insert_data;
		IF (insert_data != 0) THEN
			local_is_successful :='1';
		END IF;
        return local_is_successful;
    END;
$udf$;

-- function of create product
CREATE OR REPLACE FUNCTION import_data.add_product(
    param_products JSONB
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        i json;
		insert_data INTEGER := 0;
        cat_id INTEGER;
        subcat_id INTEGER;
    BEGIN
        FOR i IN SELECT * FROM jsonb_array_elements(param_products)
		LOOP
			RAISE NOTICE 'Name product: %', i->'name';
			if NOT EXISTS(select name from import_data.products where code = i->>'code')THEN
                SELECT id, category_id INTO subcat_id, cat_id FROM import_data.subcategories where name = i->>'subCategory';
				INSERT INTO
					import_data.products(code, category_id, subcategory_id, name)
				VALUES
					(i->>'code', cat_id, subcat_id, i->>'name');
                GET DIAGNOSTICS insert_data = ROW_COUNT;
			END IF;
		END LOOP;
		RAISE NOTICE 'INSERT product: %', insert_data;
		IF (insert_data != 0) THEN
			local_is_successful :='1';
		END IF;
        return local_is_successful;
    END;
$udf$;

-- function of create order
CREATE OR REPLACE FUNCTION import_data.add_order(
    param_orders JSONB
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        i json;
		insert_data INTEGER := 0;
        stt_id INTEGER;
        ct_id INTEGER;
        cust_id INTEGER;
    BEGIN
        FOR i IN SELECT * FROM jsonb_array_elements(param_orders)
		LOOP
			RAISE NOTICE 'city: %, state:%', i->'city', i->'state';
			if NOT EXISTS(select code from import_data.orders where code = i->>'code')THEN
                SELECT id INTO ct_id FROM import_data.cities where name = i->>'city';
                SELECT id INTO stt_id FROM import_data.states where name = i->>'state';
				RAISE NOTICE 'ct_id:  %, stt_id: %', ct_id, stt_id;
				SELECT id INTO cust_id FROM import_data.customers WHERE code = i->>'customer';
				INSERT INTO
					import_data.orders(code, customer_id, order_date, ship_date, ship_mode, state_id, city_id)
				VALUES
					(i->>'code', cust_id, TO_DATE(i->>'order_date', 'YYYY/MM/DD'), TO_DATE(i->>'ship_date', 'YYYY/MM/DD'), i->>'ship_mode', stt_id, ct_id);
                GET DIAGNOSTICS insert_data = ROW_COUNT;
			END IF;
		END LOOP;
		RAISE NOTICE 'INSERT customer: %', insert_data;
		IF (insert_data != 0) THEN
			local_is_successful :='1';
		END IF;
        return local_is_successful;
    END;
$udf$;

-- function of create order
CREATE OR REPLACE FUNCTION import_data.add_order_product(
    param_order_products JSONB
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        i json;
		insert_data INTEGER := 0;
        ord_id INTEGER;
        prod_id INTEGER;
    BEGIN
        FOR i IN SELECT * FROM jsonb_array_elements(param_order_products)
		LOOP
			RAISE NOTICE 'code order: % %', i->'order',  i->'product';
            SELECT id INTO prod_id FROM import_data.products where code = i->>'product';
            SELECT id INTO ord_id FROM import_data.orders WHERE code = i->>'order';
			if NOT EXISTS(select id from import_data.order_products where order_id =order_id AND product_id = product_id)THEN
				INSERT INTO
					import_data.order_products(order_id, product_id, sales, discount, quantity, profit)
				VALUES
					(ord_id, prod_id, CAST(i->>'sales' AS NUMERIC), CAST(i->>'discount' AS NUMERIC), CAST(i->>'quantity' AS INTEGER), CAST(i->>'profit' AS NUMERIC));
                GET DIAGNOSTICS insert_data = ROW_COUNT;
			END IF;
		END LOOP;
		RAISE NOTICE 'INSERT customer: %', insert_data;
		IF (insert_data != 0) THEN
			local_is_successful :='1';
		END IF;
        return local_is_successful;
    END;
$udf$;