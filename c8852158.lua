--影霊翼騎 ウェンディクルフ
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	-- using new function
	if aux.AddFusionProcShaddoll then
		--old function
		aux.AddFusionProcShaddoll(c,ATTRIBUTE_WIND)
	else
		--new function
		aux.AddFusionProcFun2(c,function (mc) return mc:IsFusionSetCard(0x9d) end, function (mc) return aux.FShaddollFilter2(mc,ATTRIBUTE_WIND) end, true)
	end
	--cannot spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--poschange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,0,PLAYER_ALL,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #dg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local fg=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,#dg,nil)
	if #fg>0 then
		Duel.HintSelection(fg)
		Duel.ChangePosition(fg,POS_FACEUP_DEFENSE)
	end
	local fct=fg:FilterCount(Card.IsType,nil,TYPE_FLIP)
	if fct>0 then
		local tg=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCanTurnSet),tp,LOCATION_MZONE,LOCATION_MZONE,fg)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=tg:Select(tp,1,math.min(fct,#tg),nil)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.HintSelection(sg)
				Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and aux.NecroValleyFilter(tc) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
