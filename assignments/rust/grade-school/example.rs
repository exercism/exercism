extern mod extra;
use extra::sort;
use std::hashmap::HashMap;

struct School ( HashMap<uint, ~[~str]> );

fn sorted<T: Clone + Ord>(array: &[T]) -> ~[T] {
    let mut res = array.iter().map(|v| v.clone()).to_owned_vec();
    sort::tim_sort(res);
    res
}

impl School {
    pub fn new() -> School {
        School(HashMap::new())
    }

    pub fn add(self, grade: uint, student: &str) -> School {
        let mut m = *self;
        m.mangle(
            grade,
            student,
            |_, x| ~[x.into_owned()],
            |_, xs, x| xs.push(x.into_owned()));
        School(m)
    }

    pub fn sorted(self) -> ~[(uint, ~[~str])] {
        sorted((*self).iter().map(|(&grade, students)| {
            (grade, sorted(students.clone()))
        }).to_owned_vec())
    }

    pub fn grade(self, grade: uint) -> ~[~str] {
        let default: ~[~str] = ~[];
        sorted(*(*self).find(&grade).unwrap_or(&default))
    }
}
