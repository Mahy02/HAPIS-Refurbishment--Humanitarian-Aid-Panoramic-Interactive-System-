/*
SELECT
    M.M_ID,
    M.Seek_FormID,
    M.Giver_FormID,
    CASE
        WHEN F1.User_ID = <current_user_id> THEN 'Seeker'
        WHEN F2.User_ID = <current_user_id> THEN 'Giver'
        ELSE 'Unknown'
    END AS User_Type,
    U1.First_Name AS Seeker_First_Name,
    U1.Last_Name AS Seeker_Last_Name,
    U2.First_Name AS Giver_First_Name,
    U2.Last_Name AS Giver_Last_Name,
    F1.Item AS Seeker_Item,
    F2.Item AS Giver_Item,
    F1.Category AS Seeker_Category,
    F2.Category AS Giver_Category,
    M.Rec1_Status,
    M.Rec2_Status,
    M.Donation_Status
FROM Matchings M
JOIN Forms F1 ON M.Seek_FormID = F1.Form_ID
JOIN Forms F2 ON M.Giver_FormID = F2.Form_ID
JOIN Users U1 ON F1.User_ID = U1.user_ID
JOIN Users U2 ON F2.User_ID = U2.user_ID
WHERE F1.User_ID = <current_user_id> OR F2.User_ID = <current_user_id>;

*/