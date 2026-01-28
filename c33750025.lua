--輪廻竜サンサーラ
function c33750025.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(c33750025.tricon)
	c:RegisterEffect(e1)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33750025)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33750025.thtg)
	e2:SetOperation(c33750025.thop)
	c:RegisterEffect(e2)
end
function c33750025.tricon(e,c)
	return c:IsRace(RACE_DRAGON)
end
function c33750025.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevelAbove(5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33750025.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33750025.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33750025.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33750025.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,g,0,0,0)
end
function c33750025.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND)
		and (tc:IsSummonable(true,nil,1) or tc:IsMSetable(true,nil,1))
		and Duel.SelectYesNo(tp,aux.Stringid(33750025,0)) then
		Duel.BreakEffect()
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
