extern mod extra;
use extra::sort;
use std::hashmap::HashMap;

struct School {
    priv grades: HashMap<uint, ~[~str]>
}

fn sorted<T: Clone + Ord>(array: &[T]) -> ~[T] {
    let mut res = array.iter().map(|v| v.clone()).to_owned_vec();
    sort::tim_sort(res);
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
        self.grades.find(&grade).map(|&v| sorted(v.to_owned())).unwrap_or(~[])
    }
}
