```mermaid
erDiagram
    Orders {
        int id PK "Index"
        string order_number "Unique order identifier"
        date sale_date "Date the order is confirmed"
        int channel_id FK
        int tool_user_id FK
        int buyer_id FK
        string order_status "Order status"
        datetime created_at "Order creation date"
        datetime updated_at "Order update date"
    }

    OrderItems {
        int id PK
        int order_id FK
        int sku_id FK
        int quantity
        decimal price
    }

    OrderStatusHistory {
        int id PK
        int order_id FK
        string order_status
        datetime status_change_date
        string changed_by
    }

    SalesChannels {
        int id PK
        int order_id FK
        string channel_name
        string export_domestic_flag
    }

    Buyers {
        int id PK "Index"
        string name
        int address_id FK
        string email
    }

    Addresses {
        int id PK
        string address_primary "Primary part of the address"
        string address_secondary "Additional address information (optional)"
        string city
        string state_province
        string postal_code
        string country
        string address_formats
    }

    SKUs {
        int id PK "Index"
        string sku_code
    }

    SKU_PartNumber_Links {
        int id PK
        int sku_id FK
        int product_id FK
    }

    Products {
        int id PK "Index"
        string oem_part_number "OEM part number"
        bool is_oem "Indicates if it is an OEM part"
        string domestic_title
        string international_title
        int product_categories_id FK "ProductCategory table foreign key"
        string product_status "Product status"
        datetime created_at "Product creation date"
        datetime updated_at "Product update date"
    }

    Inventories {
        int id PK
        int product_id FK "Index"
        int quantity
        date stock_order_date
        string stock_type "Type of inventory (e.g., own, manufacturer, wholesaler)"
    }

    Product_categories {
        int id PK "Index"
        string category_name
        string description
        int parent_category_id FK "Self-referencing for subcategories"
    }

    Shipments {
        int id PK
        int order_id FK
        string carrier
        string shipping_method
        float weight
        float length
        float width
        float height
        string destination_country
        string tracking_number
        float customer_domestic_shipping
        float customer_international_shipping
    }

    Procurements {
        int id PK
        int order_id FK
        decimal purchase_price
        decimal domestic_transfer_fee
        decimal forwarding_fee
        decimal photo_fee
    }

    Sales {
        int id PK
        int order_id FK
        decimal price_original
        string currency_code
        decimal conversion_rate
        decimal price_jpy
        date conversion_date "Currency conversion date"
    }



    SalesChannelFees {
        int id PK
        int sales_channel_id FK
        decimal fee_rate
    }

    PaymentFees {
        int id PK
        int order_id FK
        string fee_type
        decimal fee_rate "Fee rate (e.g., 0.03 for 3%)"
        int option "Fee option"
    }

    Expenses {
        int id PK
        int year
        int month
        string item_name
        decimal amount
    }

    AdvertisingCosts {
        int id PK
        int order_id FK
        decimal product_ad_cost
    }

    ToolUsers {
        int id PK
        string name
        string email
        string password_digest
        string profile_picture_url "Cloudinary URL for profile image"
        string role "User role (e.g., admin, staff)"
    }

    Remarks {
        int id PK
        int order_id FK
        string partner_note
        string internal_note
    }

    Quotations {
        int id PK
        int wholesaler_id FK "Wholesalers table foreign key"
        date quotation_date
        string status "Quotation status"
        date estimated_delivery
        text wholesaler_remarks "Remarks from wholesaler"
        text notes
        datetime created_at
        datetime updated_at
    }

    Wholesalers {
        int id PK
        string name
        string contact_info
        string address
        datetime created_at
        datetime updated_at
    }

    QuotationItems {
        int id PK
        int quotation_id FK
        int product_id FK
        int quantity
        decimal estimated_price
        datetime created_at
        datetime updated_at
    }

    QuotationItemChanges {
        int id PK
        int quotation_item_id FK
        string original_part_number
        string new_part_number
        datetime change_date
        string change_reason
        datetime created_at
        datetime updated_at
    }

    SalesChannels ||--o{ Orders : "channel_id"
    Orders ||--o{ OrderItems : "id"
    OrderItems }o--|| SKUs : "sku_id"
    Orders ||--o{ Remarks : "order_id"
    ToolUsers ||--o{ Orders : "tool_user_id"
    Buyers ||--o{ Orders : "buyer_id"
    Addresses ||--o{ Buyers : "address_id"
    SKUs ||--o{ SKU_PartNumber_Links : "sku_id"
    SKU_PartNumber_Links }o--|| Products : "product_id"
    Products ||--o{  Inventories: "product_id"
    Orders ||--o{ Shipments : "order_id"
    Orders ||--o{ Procurements : "order_id"
    Orders ||--o{ Sales : "order_id"
    SalesChannels ||--o{ SalesChannelFees : "sales_channel_id"
    Orders ||--o{ PaymentFees : "order_id"
    Orders ||--o{ AdvertisingCosts : "order_id"
    Product_categories ||--o{ Products : "category_id"
    Wholesalers ||--o{ Quotations : "wholesaler_id"
    Quotations ||--o{ QuotationItems : "quotation_id"
    QuotationItems }o--|| Products : "product_id"
    QuotationItems ||--o{ QuotationItemChanges : "quotation_item_id"
    Orders ||--o{ OrderStatusHistory : "order_id"
