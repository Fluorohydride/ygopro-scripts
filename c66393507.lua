--エクスクローラー・ニューロゴス
function c66393507.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66393507,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c66393507.spcon)
	e1:SetTarget(c66393507.sptg)
	e1:SetOperation(c66393507.spop)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c66393507.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--stats up
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--double damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c66393507.damtg)
	e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e5)
end
function c66393507.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function c66393507.spfilter1(c,e,tp)
	return c:IsSetCard(0x104) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		and Duel.IsExistingTarget(c66393507.spfilter2,tp,LOCATION_GRAVE,0,1,c,c:GetCode(),e,tp)
end
function c66393507.spfilter2(c,cd,e,tp)
	return not c:IsCode(cd) and c:IsSetCard(0x104) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c66393507.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c66393507.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c66393507.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c66393507.spfilter2,tp,LOCATION_GRAVE,0,1,1,tc1,tc1:GetCode(),e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c66393507.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or ft<=0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if ft<g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66393507.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x104)
end
function c66393507.damtg(e,c)
	return c:IsSetCard(0x104) and c:GetBattleTarget()~=nil and e:GetHandler():GetLinkedGroup():IsContains(c)
end
