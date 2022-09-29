--ベアルクティ－グラン＝シャリオ
function c80086070.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddGenericSpSummonProcedure(c,LOCATION_EXTRA,c80086070.sprfilter,c80086070.sprgoal,2,2,LOCATION_MZONE,0,nil,HINTMSG_TOGRAVE,Duel.SendtoGrave,REASON_COST)
	--special condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80086070,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c80086070.destg)
	e3:SetOperation(c80086070.desop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80086070,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c80086070.negcon)
	e4:SetCost(c80086070.negcost)
	e4:SetTarget(c80086070.negtg)
	e4:SetOperation(c80086070.negop)
	c:RegisterEffect(e4)
end
function c80086070.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and (c80086070.sprfilter1(c) or c80086070.sprfilter2(c))
end
function c80086070.sprfilter1(c)
	return c:IsLevelAbove(8) and c:IsType(TYPE_TUNER)
end
function c80086070.sprfilter2(c)
	return c:IsLevelAbove(1) and c:IsType(TYPE_SYNCHRO) and not c:IsType(TYPE_TUNER)
end
function c80086070.sprgoal(g,sync)
	return aux.gffcheck(g,c80086070.sprfilter1,nil,c80086070.sprfilter2,nil)
		and math.abs(g:GetFirst():GetLevel()-g:GetNext():GetLevel())==7
	if not aux.gffcheck(g,c80086070.sprfilter1,nil,c80086070.sprfilter2,nil) then return false end
end
function c80086070.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c80086070.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c80086070.negfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x163) and c:IsOnField() and c:IsControler(tp)
end
function c80086070.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c80086070.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c80086070.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsFaceup())
end
function c80086070.excostfilter(c,tp)
	return c:IsAbleToRemove() and (c:IsHasEffect(16471775,tp) or c:IsHasEffect(89264428,tp))
end
function c80086070.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(c80086070.costfilter,nil,tp)
	local g2=Duel.GetMatchingGroup(c80086070.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return #g1>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:Select(tp,1,1,nil)
	local tc=rg:GetFirst()
	local te=tc:IsHasEffect(16471775,tp) or tc:IsHasEffect(89264428,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		aux.UseExtraReleaseCount(rg,tp)
		Duel.Release(tc,REASON_COST)
	end
end
function c80086070.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c80086070.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
