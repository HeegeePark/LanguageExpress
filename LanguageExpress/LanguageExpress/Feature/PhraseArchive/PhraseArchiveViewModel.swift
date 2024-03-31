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
        var selectedTitleAppendedEvent: Observable<Int>
        var selectedTitleRemovedEvent: Observable<Int>
    }
    
    struct Output {
        var didUpdateTitleAtOnce: Observable<Bool> = Observable(false)
        var tagList: Observable<[Tag]> = Observable([])
        var pagerTabTitleList: Observable<[String]> = Observable([])
        var selectedTabIndexSet: Observable<Set<Int>> = Observable([0])
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
        output.pagerTabTitleList.value = ["전체", "북마크"] + output.tagList.value.map(\.title)
    }
    
    private func loadPhraseListByTabButton(output: Output) {
        // 0이면 "전체", 1이면 "북마크"
        print(#function, output.selectedTabIndexSet.value)
        // TODO: realm으로부터 phraseList 불러오기
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
        // TODO: selectedTabIndexSet에 따라 phraselist reload
        loadPhraseListByTabButton(output: output)
    }
}
