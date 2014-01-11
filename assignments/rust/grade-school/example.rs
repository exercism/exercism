use std::hashmap::HashMap;

pub struct School {
    priv grades: HashMap<uint, ~[~str]>
}

fn sorted<T: Clone + TotalOrd>(array: &[T]) -> ~[T] {
    let mut res = array.iter().map(|v| v.clone()).to_owned_vec();
    res.sort();
    res
}

impl School {
    pub fn new() -> School {
        School { grades: HashMap::new() }
    }

    pub fn add(self, grade: uint, student: &str) -> School {
        let mut s = self;
        s.grades.mangle(
            grade,
            student,
            |_, x| ~[x.into_owned()],
            |_, xs, x| xs.push(x.into_owned()));
        s
    }

    pub fn sorted(self) -> ~[(uint, ~[~str])] {
        sorted(self.grades.iter().map(|(&grade, students)| {
            (grade, sorted(students.clone()))
        }).to_owned_vec())
    }

    pub fn grade(self, grade: uint) -> ~[~str] {
        self.grades.find(&grade).map(|v| sorted(v.to_owned())).unwrap_or(~[])
    }
}
