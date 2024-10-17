--漆黒の豹戦士パンサーウォリアー
---@param c Card
function c42035044.initial_effect(c)
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(c42035044.atcost)
	e1:SetOperation(c42035044.atop)
	c:RegisterEffect(e1)
end
function c42035044.atcost(e,c,tp)
	return Duel.CheckReleaseGroupEx(tp,nil,1,REASON_ACTION,false,e:GetHandler())
end
function c42035044.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,REASON_ACTION,false,e:GetHandler())
	Duel.Release(g,REASON_ACTION)
end
