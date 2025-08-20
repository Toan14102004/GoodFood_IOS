//
//  DataFood.swift
//  DetectFoodApp
//
//  Created by Guest User on 5/8/25.
//

let foodKeyByLabel: [String: String] = [
    "BanhMi": "BanhMiThit",
    "BunCha": "BunCha",
    "ThitKhoTrung": "ThitKhoTrung",
    "CaKhoTo": "CaKhoTo",
    "ComTam": "ComTam",
    "GoiCuon": "GoiCuon",
    "BanhXeo": "BanhXeo",
    "ChaoGa": "ChaoGa",
    "BunBoHue": "BunBoHue",
    "XoiGa": "XoiGa"
]


let labelMapping: [String: String] = [
    "BanhMi": "Bánh mì thịt",
    "BunCha": "Bún chả nướng",
    "ThitKhoTrung": "Thịt kho trứng",
    "CaKhoTo": "Cá kho tộ",
    "ComTam": "Cơm tấm",
    "GoiCuon": "Gỏi cuốn",
    "BanhXeo": "Bánh xèo",
    "ChaoGa": "Cháo gà",
    "BunBoHue": "Bún bò huế",
    "XoiGa": "Xôi gà"
]


let foodDatabase: [String: FoodInfo] = [
    "BanhMi": FoodInfo(
        name: "Bánh mì thịt",
        ingredients: [
            IngredientLite(name: "Bánh mì", unit: "ổ", state: nil, quantity: 1),
            IngredientLite(name: "Thịt nguội", unit: "g", state: "cắt lát", quantity: 50),
            IngredientLite(name: "Dưa leo", unit: "g", state: "thái mỏng", quantity: 30),
            IngredientLite(name: "Rau ngò", unit: "g", state: nil, quantity: 5),
            IngredientLite(name: "Pate", unit: "g", state: nil, quantity: 20)
        ],
        nutritionFacts: NutritionFacts(
            calories: 400,
            fat: 18,
            saturatedFat: 6,
            protein: 15,
            carbohydrates: 45,
            sugar: 5,
            fiber: 3,
            cholesterol: 30,
            sodium: 700,
            calcium: 60,
            iron: 3,
            potassium: 250
        )
    ),

    "BunBoHue": FoodInfo(
        name: "Bún bò Huế",
        ingredients: [
            IngredientLite(name: "Bún", unit: "g", state: "luộc", quantity: 200),
            IngredientLite(name: "Thịt bò", unit: "g", state: "nấu chín", quantity: 100),
            IngredientLite(name: "Chả lụa", unit: "g", state: nil, quantity: 50),
            IngredientLite(name: "Hành ngò", unit: "g", state: "cắt nhỏ", quantity: 5)
        ],
        nutritionFacts: NutritionFacts(
            calories: 550,
            fat: 20,
            saturatedFat: 7,
            protein: 25,
            carbohydrates: 50,
            sugar: 3,
            fiber: 2,
            cholesterol: 50,
            sodium: 1000,
            calcium: 80,
            iron: 4,
            potassium: 300
        )
    ),

    "ChaoGa": FoodInfo(
        name: "Cháo gà",
        ingredients: [
            IngredientLite(name: "Gạo", unit: "g", state: "nấu chín", quantity: 100),
            IngredientLite(name: "Thịt gà", unit: "g", state: "luộc xé", quantity: 80),
            IngredientLite(name: "Hành lá", unit: "g", state: "cắt nhỏ", quantity: 5),
            IngredientLite(name: "Gừng", unit: "g", state: "băm nhuyễn", quantity: 2)
        ],
        nutritionFacts: NutritionFacts(
            calories: 350,
            fat: 8,
            saturatedFat: 2,
            protein: 20,
            carbohydrates: 45,
            sugar: 1,
            fiber: 1,
            cholesterol: 60,
            sodium: 700,
            calcium: 20,
            iron: 1.5,
            potassium: 250
        )
    ),

    "CaKhoTo": FoodInfo(
        name: "Cá kho tộ",
        ingredients: [
            IngredientLite(name: "Cá basa", unit: "g", state: "kho", quantity: 150),
            IngredientLite(name: "Nước mắm", unit: "ml", state: nil, quantity: 10),
            IngredientLite(name: "Đường", unit: "g", state: "nước màu", quantity: 5),
            IngredientLite(name: "Tiêu", unit: "g", state: "xay", quantity: 1)
        ],
        nutritionFacts: NutritionFacts(
            calories: 300,
            fat: 15,
            saturatedFat: 4,
            protein: 30,
            carbohydrates: 5,
            sugar: 2,
            fiber: 0,
            cholesterol: 80,
            sodium: 900,
            calcium: 40,
            iron: 1.8,
            potassium: 400
        )
    ),

    "ThitKhoTrung": FoodInfo(
        name: "Thịt kho trứng",
        ingredients: [
            IngredientLite(name: "Thịt ba rọi", unit: "g", state: "kho", quantity: 100),
            IngredientLite(name: "Trứng gà", unit: "quả", state: "luộc", quantity: 1),
            IngredientLite(name: "Nước dừa", unit: "ml", state: "kho", quantity: 100),
            IngredientLite(name: "Nước mắm", unit: "ml", state: nil, quantity: 10)
        ],
        nutritionFacts: NutritionFacts(
            calories: 450,
            fat: 30,
            saturatedFat: 10,
            protein: 25,
            carbohydrates: 10,
            sugar: 3,
            fiber: 0,
            cholesterol: 120,
            sodium: 1000,
            calcium: 50,
            iron: 2.5,
            potassium: 350
        )
    ),

    "XoiGa": FoodInfo(
        name: "Xôi gà",
        ingredients: [
            IngredientLite(name: "Nếp", unit: "g", state: "hấp", quantity: 200),
            IngredientLite(name: "Thịt gà", unit: "g", state: "xé", quantity: 80),
            IngredientLite(name: "Hành phi", unit: "g", state: "chiên", quantity: 5)
        ],
        nutritionFacts: NutritionFacts(
            calories: 500,
            fat: 15,
            saturatedFat: 4,
            protein: 20,
            carbohydrates: 70,
            sugar: 2,
            fiber: 2,
            cholesterol: 60,
            sodium: 800,
            calcium: 30,
            iron: 1.5,
            potassium: 300
        )
    ),

    "BunCha": FoodInfo(
        name: "Bún chả",
        ingredients: [
            IngredientLite(name: "Bún", unit: "g", state: "luộc", quantity: 200),
            IngredientLite(name: "Thịt ba chỉ", unit: "g", state: "nướng", quantity: 100),
            IngredientLite(name: "Nước mắm pha", unit: "ml", state: nil, quantity: 50),
            IngredientLite(name: "Rau sống", unit: "g", state: "rửa sạch", quantity: 50)
        ],
        nutritionFacts: NutritionFacts(
            calories: 600,
            fat: 25,
            saturatedFat: 8,
            protein: 30,
            carbohydrates: 55,
            sugar: 6,
            fiber: 3,
            cholesterol: 70,
            sodium: 1200,
            calcium: 40,
            iron: 2.2,
            potassium: 350
        )
    ),

    "BanhXeo": FoodInfo(
        name: "Bánh xèo",
        ingredients: [
            IngredientLite(name: "Bột bánh xèo", unit: "g", state: "rán", quantity: 100),
            IngredientLite(name: "Tôm", unit: "g", state: "rán", quantity: 50),
            IngredientLite(name: "Thịt ba chỉ", unit: "g", state: "rán", quantity: 50),
            IngredientLite(name: "Giá đỗ", unit: "g", state: "xào sơ", quantity: 30)
        ],
        nutritionFacts: NutritionFacts(
            calories: 450,
            fat: 20,
            saturatedFat: 6,
            protein: 20,
            carbohydrates: 45,
            sugar: 2,
            fiber: 2,
            cholesterol: 80,
            sodium: 900,
            calcium: 35,
            iron: 1.8,
            potassium: 300
        )
    ),

    "GoiCuon": FoodInfo(
        name: "Gỏi cuốn",
        ingredients: [
            IngredientLite(name: "Bánh tráng", unit: "cái", state: "cuốn", quantity: 2),
            IngredientLite(name: "Tôm luộc", unit: "g", state: nil, quantity: 50),
            IngredientLite(name: "Thịt ba chỉ luộc", unit: "g", state: nil, quantity: 50),
            IngredientLite(name: "Bún", unit: "g", state: "luộc", quantity: 50),
            IngredientLite(name: "Rau sống", unit: "g", state: "rửa sạch", quantity: 30)
        ],
        nutritionFacts: NutritionFacts(
            calories: 250,
            fat: 8,
            saturatedFat: 2,
            protein: 15,
            carbohydrates: 30,
            sugar: 2,
            fiber: 2,
            cholesterol: 60,
            sodium: 600,
            calcium: 30,
            iron: 1.2,
            potassium: 250
        )
    ),

    "ComTam": FoodInfo(
        name: "Cơm tấm",
        ingredients: [
            IngredientLite(name: "Cơm tấm", unit: "g", state: "nấu chín", quantity: 200),
            IngredientLite(name: "Sườn nướng", unit: "g", state: "nướng", quantity: 100),
            IngredientLite(name: "Bì", unit: "g", state: "trộn thính", quantity: 30),
            IngredientLite(name: "Chả trứng", unit: "g", state: "hấp", quantity: 50),
            IngredientLite(name: "Mỡ hành", unit: "g", state: "phi", quantity: 10),
            IngredientLite(name: "Nước mắm", unit: "ml", state: "pha", quantity: 30),
            IngredientLite(name: "Dưa leo & cà chua", unit: "g", state: "tươi", quantity: 30)
        ],
        nutritionFacts: NutritionFacts(
            calories: 750,
            fat: 30,
            saturatedFat: 10,
            protein: 35,
            carbohydrates: 80,
            sugar: 6,
            fiber: 3,
            cholesterol: 90,
            sodium: 1200,
            calcium: 50,
            iron: 2.5,
            potassium: 400
        )
    )
]
