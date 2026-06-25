--２つに１つ
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.chkfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_TRAP) and c:IsAbleToRemove()
end
function s.chkfilter2(c,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and c:IsType(TYPE_MONSTER)
end
function s.fslect(g,e,tp)
	return g:IsExists(Card.IsType,2,nil,TYPE_TRAP) and g:IsExists(s.chkfilter2,1,nil,e,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(s.fslect,3,3,e,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_DECK,0,nil)
	if not g:CheckSubGroup(s.fslect,3,3,e,tp) then return end
	local sg=g:SelectSubGroup(tp,s.fslect,false,3,3,e,tp)
	if not sg then return end
	Duel.ConfirmCards(1-tp,sg)
	local tc1=sg:RandomSelect(1-tp,1):GetFirst()
	local tg=sg-tc1
	Duel.ConfirmCards(tp,tg)
	local tc2=tg:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_TRAP)
	local fg=tg-tc2
	local tc3=fg:GetFirst()
	if Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local op=aux.SelectFromOptions(1-tp,
			{true,aux.Stringid(id,1),1},
			{true,aux.Stringid(id,2),2})
		if op==1 then
			Duel.ConfirmCards(tp,tc1)
			Duel.ConfirmCards(1-tp,tc1)
			if tc1:IsType(TYPE_MONSTER) then
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local spchk=tc1:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft>0
				if tc1:IsAbleToHand() and (not spchk or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(tc1,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc1)
				elseif spchk then
					Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
				end
			else
				Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
			end
		elseif op==2 then
			Duel.ConfirmCards(tp,tc3)
			Duel.ConfirmCards(1-tp,tc3)
			if tc3:IsType(TYPE_MONSTER) then
				if tc3:IsAbleToHand() then
					Duel.SendtoHand(tc3,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc3)
				else
					Duel.SendtoGrave(tc3,REASON_RULE)
				end
			else
				Duel.Remove(tc3,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
	Duel.ShuffleDeck(tp)
end
