// List<LeadQuestions> screensList = [
//   LeadQuestions(
//     screens: [
//       Screen(
//         questions: [
//           Question(
//             questionId: 1,
//             questionOptionType: "chip",
//             questionTitle:
//                 "Which Property Category does this inventory Fall under ?",
//             questionOption: ["Residential", "Commercial"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "",
//         screenId: "S1",
//         nextScreenId: "S2",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 2,
//             questionOptionType: "chip",
//             questionTitle: "What Category does this inventory belong to?",
//             questionOption: ["Rent", "Sell"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S1",
//         screenId: "S2",
//         nextScreenId: "S3",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 3,
//             questionOptionType: "chip",
//             questionTitle: "What is the specific type of Property?",
//             questionOption: ["Direct", "Broker"],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S2",
//         screenId: "S3",
//         nextScreenId: "S4",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 4,
//             questionOptionType: "chip",
//             questionTitle: "From where did you source this inventory?",
//             questionOption: [
//               "99Acers",
//               "Magic Bricks",
//               "Makaan",
//               "Housing.com",
//               "Social Media",
//               "Data Calling",
//               "Other"
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S3",
//         screenId: "S4",
//         nextScreenId: "S5",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 5,
//             questionOptionType: "textfield",
//             questionTitle: "First Name",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 6,
//             questionOptionType: "textfield",
//             questionTitle: "Last Name",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 7,
//             questionOptionType: "textfield",
//             questionTitle: "Mobile",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 8,
//             questionOptionType: "textfield",
//             questionTitle: "Whatsapp Number",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 9,
//             questionOptionType: "textfield",
//             questionTitle: "Email",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 10,
//             questionOptionType: "textfield",
//             questionTitle: "Company Name",
//             questionOption: "",
//           ),
//         ],
//         title: "Customer Details",
//         isActive: true,
//         previousScreenId: "S4",
//         screenId: "S5",
//         nextScreenId: "S6",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 11,
//             questionOptionType: "dropdown",
//             questionTitle: "No of Bedrooms?",
//             questionOption: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
//           ),
//           Question(
//             questionId: 12,
//             questionOptionType: "multichip",
//             questionTitle: "Additional Rooms?",
//             questionOption: ["Study", "Servant", "Office", "Puja"],
//           ),
//           Question(
//             questionId: 13,
//             questionOptionType: "dropdown",
//             questionTitle: "No of Bathrooms?",
//             questionOption: ["1", "2", "3", "4", "5"],
//           ),
//           Question(
//             questionId: 14,
//             questionOptionType: "dropdown",
//             questionTitle: "No of Balconies?",
//             questionOption: ["1", "2", "3", "4", "5"],
//           ),
//         ],
//         title: "Room Details",
//         isActive: true,
//         previousScreenId: "S5",
//         screenId: "S6",
//         nextScreenId: "S7",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 15,
//             questionOptionType: "dropdown",
//             questionTitle: "Is there a boundary around the plot?",
//             questionOption: ["Yes", "No"],
//           ),
//           Question(
//             questionId: 16,
//             questionOptionType: "smallchip",
//             questionTitle: "No of open Sides?",
//             questionOption: ["1", "2", "3", "4"],
//           ),
//         ],
//         isActive: true,
//         title: "Plot Details",
//         previousScreenId: "S6",
//         screenId: "S7",
//         nextScreenId: "S8",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 17,
//             questionOptionType: "chip",
//             questionTitle: "Expected time possession ?",
//             questionOption: [
//               "Within 3 months",
//               "Within 3 months",
//               "Within 1 Year",
//               "Within 2 Year",
//               "Within 3 Year"
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S7",
//         screenId: "S8",
//         nextScreenId: "S9",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 18,
//             questionOptionType: "multichip",
//             questionTitle:
//                 "What are the amenities available with this property?",
//             questionOption: [
//               "Power Backup",
//               "24 X 7 security",
//               "Lift",
//               "Gym",
//               "Swimming Pool",
//               "Club House Park",
//               "Garden"
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S8",
//         screenId: "S9",
//         nextScreenId: "S10",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 19,
//             questionOptionType: "smallchip",
//             questionTitle: "Property Area",
//             questionOption: ["Sq ft", "Sq yard", "Acre"],
//           ),
//           Question(
//             questionId: 20,
//             questionOptionType: "textfield",
//             questionTitle: "Expected Area Range",
//             questionOption: "",
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S9",
//         screenId: "S10",
//         nextScreenId: "S11",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 21,
//             questionOptionType: "dropdown",
//             questionTitle: "State",
//             questionOption: [],
//           ),
//           Question(
//             questionId: 22,
//             questionOptionType: "dropdown",
//             questionTitle: "City",
//             questionOption: [],
//           ),
//           Question(
//             questionId: 23,
//             questionOptionType: "textfield",
//             questionTitle: "Address Line 1",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 24,
//             questionOptionType: "textfield",
//             questionTitle: "Address Line 2",
//             questionOption: "",
//           ),
//           Question(
//             questionId: 25,
//             questionOptionType: "textfield",
//             questionTitle: "Floor Number",
//             questionOption: "",
//           ),
//         ],
//         title: "Preferred Locality",
//         isActive: true,
//         previousScreenId: "S10",
//         screenId: "S11",
//         nextScreenId: "S12",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 26,
//             questionOptionType: "chip",
//             questionTitle: "Preferred Property Direction",
//             questionOption: [
//               "East",
//               "West",
//               "North",
//               "South",
//               "North East",
//               "North West",
//               "South East",
//               "South West"
//             ],
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S11",
//         screenId: "S12",
//         nextScreenId: "S13",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 27,
//             questionOptionType: "textarea",
//             questionTitle: "Add Note Or comment",
//             questionOption: "Add Note or comment",
//           ),
//         ],
//         isActive: true,
//         previousScreenId: "S12",
//         screenId: "S13",
//         nextScreenId: "S14",
//       ),
//       Screen(
//         questions: [
//           Question(
//             questionId: 28,
//             questionOptionType: "Assign",
//             questionTitle: "Assign to",
//             questionOption: "",
//           ),
//         ],
//         isActive: true,
//         title: "Assign to",
//         previousScreenId: "S13",
//         screenId: "S14",
//         nextScreenId: "S15",
//       ),
//     ],
//   ),
// ];
