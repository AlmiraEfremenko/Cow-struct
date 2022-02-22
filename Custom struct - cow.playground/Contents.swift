import UIKit

// Механизм copy on write работаем для массивов и строк(причем если значение строки не короткое) по дефолту. А если придется писать кастомную структура с реализацией COW ....

func address(off value: AnyObject) -> String {
    return "\(Unmanaged.passUnretained(value).toOpaque())"
}

struct Identifier {
    var id = "1"
}

class Ref<T> {   //  cоздали класс который хранит ссылку
    var value: T
    
    init(value: T) {
        self.value = value
    }
}

struct Box<T> {
    var ref: Ref<T>
    
    init(value: T) {
        self.ref = Ref(value: value)
    }
    
    var value: T {
        
        get {
            ref.value                           // при чтении будет один и тот же адрес
        }
        
        set {
            guard (isKnownUniquelyReferenced(&ref)) else {         // проверим на уникальность ссылку
                ref = Ref(value: newValue)                         // если ссылка на объект есть - то сделаем перезапись
                return
            }
            ref.value = newValue
        }
    }
}

var id = Identifier()
var box1 = Box(value: id)
var box2 = box1
address(off: box1.ref)
address(off: box2.ref)
box1.value.id = "2"
address(off: box1.ref)
address(off: box2.ref)
