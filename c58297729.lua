--変則ギア
function c58297729.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetTarget(c58297729.target)
	e1:SetOperation(c58297729.activate)
	c:RegisterEffect(e1)
	if not Duel.RockPaperScissors then
		function Duel.RockPaperScissors()
			local rock,paper,xors=0,0,0
			if c101001180 then
				rock=101001180
			else
				rock=71786742
			end
			if c101001181 then
				paper=101001181
			else
				paper=45286019
			end
			if c101001182 then
				xors=101001182
			else
				xors=1045143
			end
			local rocktemp=Duel.CreateToken(0,rock)
			local papertemp=Duel.CreateToken(0,paper)
			local xorstemp=Duel.CreateToken(0,xors)
			local ch=Group.FromCards(rocktemp,papertemp,xorstemp)
			Duel.Remove(ch,POS_FACEUP,REASON_RULE)
			local res=-1
			repeat
				local r0=ch:Select(0,1,1,nil)
				local r1=ch:Select(1,1,1,nil)
				local rct0=r0:GetFirst():GetCode()
				local rct1=r1:GetFirst():GetCode()
				Duel.Hint(HINT_CARD,1,rct0)
				Duel.Hint(HINT_CARD,0,rct1)
				if rct0==rct1 then
					res=-1
				elseif ((rct0 == rock and rct1 == paper) or (rct0 == paper and rct1 == xors) or (rct0 == xors and rct1 == rock)) then
					res=1
				else
					res=0
				end
			until res==0 or res==1
			Duel.SendtoDeck(ch,nil,-2,REASON_RULE)
			return res
		end
	end
end
function c58297729.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return d and a:GetControler()~=d:GetControler()
		and a:IsAbleToRemove() and d:IsAbleToRemove() end
end
function c58297729.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	local res=Duel.RockPaperScissors()
	if res==tp then
		Duel.Remove(d,POS_FACEDOWN,REASON_RULE)
	else
		Duel.Remove(a,POS_FACEDOWN,REASON_RULE)
	end
end
