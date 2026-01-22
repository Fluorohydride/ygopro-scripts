--アブダクション
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,c)
end
function s.rmfilter(c,ec)
	local eq=false
	if c:IsAllTypes(TYPE_LINK+TYPE_MONSTER) then
		eq=ec:IsAllTypes(TYPE_LINK+TYPE_MONSTER) and c:GetLink()==ec:GetLink()
	elseif c:IsAllTypes(TYPE_XYZ+TYPE_MONSTER) then
		eq=ec:IsAllTypes(TYPE_XYZ+TYPE_MONSTER) and c:GetOriginalRank()==ec:GetOriginalRank()
	else
		eq=c:GetOriginalLevel()==ec:GetOriginalLevel()
	end
	return eq and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
		and c:GetOriginalRace()&ec:GetOriginalRace()~=0
		and c:GetOriginalAttribute()&ec:GetOriginalAttribute()~=0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tc)
		if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			local rc=g:GetFirst()
			if Duel.GetControl(tc,tp)~=0 and tc:GetOriginalCode()==rc:GetOriginalCode() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
