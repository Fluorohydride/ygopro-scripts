--パーペチュアルキングデーモン
function c35606858.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FIEND),2,2)
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c35606858.mtcon)
	e1:SetOperation(c35606858.mtop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35606858,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c35606858.tgcon)
	e2:SetCost(c35606858.tgcost)
	e2:SetTarget(c35606858.tgtg)
	e2:SetOperation(c35606858.tgop)
	c:RegisterEffect(e2)
	--dice
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35606858,1))
	e3:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CUSTOM+35606858)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c35606858.dccost)
	e3:SetTarget(c35606858.dctg)
	e3:SetOperation(c35606858.dcop)
	c:RegisterEffect(e3)
	--check
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(g)
	e4:SetOperation(c35606858.check)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetLabelObject(g)
	e5:SetCondition(c35606858.regcon)
	e5:SetOperation(c35606858.regop)
	c:RegisterEffect(e5)
end
c35606858.toss_dice=true
function c35606858.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c35606858.mtop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.CheckLPCost(tp,500) or Duel.IsPlayerAffectedByEffect(tp,94585852))
		and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(35606858,2)) then
		if not Duel.IsPlayerAffectedByEffect(tp,94585852)
			or not Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(94585852,1)) then
			Duel.PayLPCost(tp,500)
		end
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c35606858.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c35606858.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(35606858)==0 end
	c:RegisterFlagEffect(35606858,RESET_CHAIN,0,1)
end
function c35606858.tgfilter(c,val)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER) and (c:IsAttack(val) or c:IsDefense(val)) and c:IsAbleToGrave()
end
function c35606858.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35606858.tgfilter,tp,LOCATION_DECK,0,1,nil,ev) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c35606858.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c35606858.tgfilter,tp,LOCATION_DECK,0,1,1,nil,ev)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c35606858.dccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(35606859)==0 end
	c:RegisterFlagEffect(35606859,RESET_CHAIN,0,1)
end
function c35606858.cfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
		and (c:IsAbleToHand() or c:IsAbleToDeck() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c35606858.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummon(tp) and eg:IsExists(c35606858.cfilter,1,nil,e,tp) and eg:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c35606858.dcop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	local g=eg:Filter(aux.NecroValleyFilter(c35606858.cfilter),nil,e,tp)
	if g:GetCount()==0 then return end
	local tc=nil
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	if d==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	elseif d==6 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	elseif d>=2 and d<=5 then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c35606858.check(e,tp,eg)
	e:GetLabelObject():Merge(eg)
end
function c35606858.regcon(e)
	return e:GetLabelObject():GetCount()>0 and Duel.GetCurrentChain()==0
end
function c35606858.regop(e)
	local g=e:GetLabelObject()
	g:AddCard(e:GetHandler())
	Duel.RaiseEvent(g,EVENT_CUSTOM+35606858,e,0,0,0,0)
	g:Clear()
end
