--魔界劇団－ダンディ・バイプレイヤー
function c39024589.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39024589,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c39024589.thcon)
	e1:SetTarget(c39024589.thtg)
	e1:SetOperation(c39024589.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39024589,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,39024589)
	e2:SetCondition(c39024589.spcon)
	e2:SetCost(c39024589.spcost)
	e2:SetTarget(c39024589.sptg)
	e2:SetOperation(c39024589.spop)
	c:RegisterEffect(e2)
end
function c39024589.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c39024589.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c39024589.cfilter,1,nil,tp)
end
function c39024589.thfilter(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0x10ec) and (lv==1 or lv==8) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c39024589.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39024589.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c39024589.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c39024589.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c39024589.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return tc1 and tc1:IsSetCard(0x10ec) and tc2 and tc2:IsSetCard(0x10ec)
end
function c39024589.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c39024589.filter(c,e,tp)
	local lv=c:GetLevel()
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA))) and c:IsSetCard(0x10ec)
		and (lv==1 or lv==8) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c39024589.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c39024589.filter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function c39024589.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c39024589.filter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
