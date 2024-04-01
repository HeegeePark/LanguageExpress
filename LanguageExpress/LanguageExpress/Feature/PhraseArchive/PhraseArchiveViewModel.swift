//
//  PhraseArchiveViewModel.swift
//  LanguageExpress
//
//  Created by 박희지 on 3/30/24.
//

import Foundation

final class PhraseArchiveViewModel: ViewModelAvailable {
    struct Input {
        var viewDidLoadEvent: Observable<Void?>
        var viewDidAppearEvent: Observable<Void?>
        var phraseCollectionViewCellBookMarkButtonTappedEvent: Observable<Int>
        var phraseCollectionViewCellStateOfMemorizationButtonTappedEvent: Observable<Int>
        var selectedTitleAppendedEvent: Observable<Int>
        var selectedTitleRemovedEvent: Observable<Int>
    }
    
    struct Output {
        var didUpdateTitleAtOnce: Observable<Bool> = Observable(false)
        var tagList: Observable<[Tag]> = Observable([])
        var pagerTabTitleList: Observable<[String]> = Observable([])
        var selectedTabIndexSet: Observable<Set<Int>> = Observable([])
        var phraseList: Observable<[Phrase]> = Observable([])
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent.bind { event in
            guard event != nil else { return }
            self.loadTagList(output: output)
            self.loadPhraseListByTabButton(output: output)
            self.checkUpdateTitleOnce(output: output)
        }
        
        input.viewDidAppearEvent.bind { event in
            guard event != nil else { return }
            self.loadTagList(output: output)
            self.loadPhraseListByTabButton(output: output)
        }
        
        input.phraseCollectionViewCellBookMarkButtonTappedEvent.bind { idx in
            guard 0..<output.phraseList.value.count ~= idx else { return }
            let phrase = output.phraseList.value[idx]
            self.toggleIsBookMark(phrase: phrase, output: output)
        }
        
        input.phraseCollectionViewCellStateOfMemorizationButtonTappedEvent.bind { idx in
            guard 0..<output.phraseList.value.count ~= idx else { return }
            let phrase = output.phraseList.value[idx]
            self.changeStateOfMemorization(phrase: phrase, output: output)
        }
        
        input.selectedTitleAppendedEvent.bind { idx in
            guard 0..<output.pagerTabTitleList.value.count ~= idx  else { return }
            self.appendSelectedTitle(at: idx, output: output)
        }
        
        input.selectedTitleRemovedEvent.bind { idx in
            guard 0..<output.pagerTabTitleList.value.count ~= idx  else { return }
            self.removeSelectedTitle(at: idx, output: output)
        }
        
        return output
    }
    
    private func checkUpdateTitleOnce(output: Output) {
        output.didUpdateTitleAtOnce.value = true
    }
    
    private func loadTagList(output: Output) {
        output.tagList.value = RealmManager.shared.tagList()
        output.pagerTabTitleList.value = ["북마크"] + output.tagList.value.map(\.title)
    }
    
    private func loadPhraseListByTabButton(output: Output) {
        // 0이면 "북마크", 비었으면 "전체"
        guard !output.selectedTabIndexSet.value.isEmpty else {
            output.phraseList.value = RealmManager.shared.phraseList()
            return
        }
        
        let filterBookMark = output.selectedTabIndexSet.value.contains(0)
        var selectedTags = [Tag]()
        
        if filterBookMark {
            var temp = output.selectedTabIndexSet.value
            temp.remove(0)
            selectedTags = temp.map {
                return output.tagList.value[$0 - 1]
            }
        } else {
            selectedTags = output.selectedTabIndexSet.value.map {
                return output.tagList.value[$0 - 1]
            }
        }
        
        let phrases = RealmManager.shared.phraseListByTag(filterBookMark, tagList: selectedTags)
        output.phraseList.value = phrases
    }
    
    private func appendSelectedTitle(at idx: Int, output: Output) {
        output.selectedTabIndexSet.value.insert(idx)
        updateSelectedTitle(output: output)
    }
    
    private func removeSelectedTitle(at idx: Int, output: Output) {
        output.selectedTabIndexSet.value.remove(idx)
        updateSelectedTitle(output: output)
    }
    
    private func updateSelectedTitle(output: Output) {
        loadPhraseListByTabButton(output: output)
    }
    
    func toggleIsBookMark(phrase: Phrase, output: Output) {
        RealmManager.shared.toggleIsBookMark(phrase: phrase)
        loadPhraseListByTabButton(output: output)
    }
    
    func changeStateOfMemorization(phrase: Phrase, output: Output) {
        RealmManager.shared.changeStateOfMemorization(phrase: phrase)
        loadPhraseListByTabButton(output: output)
    }
}
