#[crate_id = "grade-school_test#1.0"];
#[crate_type = "lib"];

mod school;

#[test]
fn test_add_student() {
    assert_eq!(school::School::new().add(2, "Aimee").sorted(), ~[(2, ~[~"Aimee"])]);
}

#[test]
fn test_add_more_students_in_same_class() {
    assert_eq!(
        school::School::new()
            .add(2, "James")
            .add(2, "Blair")
            .add(2, "Paul")
            .sorted(),
        ~[(2, ~[~"Blair", ~"James", ~"Paul"])]);
}

#[test]
fn test_add_students_to_different_grades() {
    assert_eq!(
        school::School::new()
            .add(3, "Chelsea")
            .add(7, "Logan")
            .sorted(),
        ~[(3, ~[~"Chelsea"]), (7, ~[~"Logan"])]);
}

#[test]
fn test_get_students_in_a_grade() {
    assert_eq!(
        school::School::new()
            .add(5, "Franklin")
            .add(5, "Bradley")
            .add(1, "Jeff")
            .grade(5),
        ~[~"Bradley", ~"Franklin"]);
}

#[test]
fn test_get_students_in_a_non_existent_grade() {
    assert_eq!(school::School::new().grade(1), ~[]);
}

#[test]
fn test_sorted_school() {
    assert_eq!(
        school::School::new()
            .add(4, "Jennifer")
            .add(6, "Kareem")
            .add(4, "Christopher")
            .add(3, "Kyle")
            .sorted(),
        ~[(3, ~[~"Kyle"]),
          (4, ~[~"Christopher", ~"Jennifer"]),
          (6, ~[~"Kareem"])]);
}
