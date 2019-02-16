--デンジャラス・デストーイ・ナイトメアリー
function c58468105.initial_effect(c)
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc3),aux.FilterBoolFunction(Card.IsFusionSetCard,0xa9),2,99,false)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c58468105.value)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c58468105.tgcon)
	e2:SetTarget(c58468105.tgtg)
	e2:SetOperation(c58468105.tgop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c58468105.discon)
	e3:SetCost(c58468105.discost)
	e3:SetTarget(c58468105.distg)
	e3:SetOperation(c58468105.disop)
	c:RegisterEffect(e3)
end
function c58468105.atkfilter(c)
	return c:IsRace(RACE_FAIRY+RACE_FIEND)
end
function c58468105.value(e,c)
	local tp=c:GetControler()
	if Duel.GetTurnPlayer()~=tp then return 0 end
	return Duel.GetMatchingGroupCount(c58468105.atkfilter,tp,LOCATION_GRAVE,0,nil)*300
end
function c58468105.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and aux.bdocon(e,tp,eg,ep,ev,re,r,rp)
end
function c58468105.tgfilter(c)
	return (c:IsSetCard(0xc3) or c:IsSetCard(0xa9) or c:IsSetCard(0xad)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c58468105.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local lv=bc:GetLevel()
	e:SetLabel(lv)
	if chk==0 then return Duel.IsExistingMatchingCard(c58468105.tgfilter,tp,LOCATION_DECK,lv,lv,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c58468105.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local lv=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c58468105.tgfilter,tp,LOCATION_DECK,0,lv,lv,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c58468105.costfilter(c)
	return c:IsSetCard(0xad) and c:IsAbleToRemoveAsCost()
end
function c58468105.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58468105.costfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c58468105.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c58468105.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not rp==1-tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainDisablable(ev)
end
function c58468105.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c58468105.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
