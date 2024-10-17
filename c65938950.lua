--綱引犬会
--not fully implemented
---@param c Card
function c65938950.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65938950.drcon)
	e2:SetCost(c65938950.drcost)
	e2:SetTarget(c65938950.drtg)
	e2:SetOperation(c65938950.drop)
	c:RegisterEffect(e2)
	--loss lp
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EVENT_CUSTOM+65938950)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c65938950.lptg)
	e3:SetOperation(c65938950.lpop)
	c:RegisterEffect(e3)
end
function c65938950.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RULE and tp==Duel.GetTurnPlayer()
end
function c65938950.tdfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_TUNER)
end
function c65938950.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c65938950.tdfilter,1,nil)
	if chk==0 then return #tg>0 end
	local tunp=Duel.GetTurnPlayer()
	local tc=tg:GetFirst()
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,tunp,HINTMSG_CONFIRM)
		tc=tg:Select(tunp,1,1,nil):GetFirst()
	end
	Duel.ConfirmCards(1-tunp,tc)
	Duel.ShuffleHand(tunp)
end
function c65938950.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tunp=Duel.GetTurnPlayer()
	if chk==0 then return Duel.IsPlayerCanDraw(tunp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tunp,2)
end
function c65938950.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tunp=Duel.GetTurnPlayer()
	local cp=e:GetHandlerPlayer()
	if Duel.Draw(tunp,2,REASON_EFFECT)>0 and tunp~=cp then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+65938950,e,0,cp,0,0)
	end
end
function c65938950.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
end
function c65938950.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-2000)
	if Duel.GetLP(tp)<lp and c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
