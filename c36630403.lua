--妖刀－不知火
function c36630403.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,36630403)
	e1:SetCondition(aux.exccon)
	e1:SetTarget(c36630403.target)
	e1:SetOperation(c36630403.operation)
	c:RegisterEffect(e1)
end
function c36630403.filter1(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c36630403.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c36630403.filter2(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c36630403.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c36630403.filter1(chkc,e,tp,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(c36630403.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c36630403.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetLevel())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c36630403.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lv=c:GetLevel()+tc:GetLevel()
	local g=Group.FromCards(c,tc)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==2 then
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c36630403.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
