--水精鱗－オーケアビス
---@param c Card
function c28577986.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(28577986,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,28577986)
	e1:SetTarget(c28577986.target)
	e1:SetOperation(c28577986.operation)
	c:RegisterEffect(e1)
end
function c28577986.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsSetCard(0x74)
		and Duel.IsExistingMatchingCard(c28577986.spfilter,tp,LOCATION_DECK,0,1,nil,lv,e,tp)
end
function c28577986.spfilter(c,lv,e,tp)
	if lv>4 then lv=4 end
	return c:IsLevelBelow(lv) and c:IsSetCard(0x74) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28577986.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c28577986.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c28577986.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c28577986.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c28577986.gselect(g,slv)
	return g:GetSum(Card.GetLevel)<=slv
end
function c28577986.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local slv=tc:GetLevel()
	local sg=Duel.GetMatchingGroup(c28577986.spfilter,tp,LOCATION_DECK,0,nil,slv,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:SelectSubGroup(tp,c28577986.gselect,false,1,ft,slv)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
